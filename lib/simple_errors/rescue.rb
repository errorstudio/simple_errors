module SimpleErrors
  # A mixin for ApplicationController which rescues from common errors. If you have specific ones you want to rescue
  # with a 404, call the class method rescue_with_not_found, passing one or more error classes
  module Rescue
    extend ActiveSupport::Concern

    included do
      @@rescue_with_not_found_from ||= []
      rescue_from StandardError do |e|
        #if we're considering all requests to be local, raise the error
        if ::Rails.application.config.consider_all_requests_local
          raise e
        end

        if e.class.in?(@@rescue_with_not_found_from + [ActiveRecord::RecordNotFound, ActionController::RoutingError])
          render_not_found(e)
        else
          render_error(e)
        end

        # If rollbar is defined, send a message to it.
        if defined?(Rollbar)
          Rollbar.error(e, rollbar_request_data, rollbar_person_data)
        end

      end
    end

    class_methods do
      def rescue_with_not_found(*klasses)
        @@rescue_with_not_found_from ||= []
        @@rescue_with_not_found_from << klasses
        @@rescue_with_not_found_from.flatten!
      end

      def before_rescue(&block)
        @@before_rescue = block
      end
    end



    def render_not_found(exception = nil)
      call_before_rescue_block
      @exception = exception
      respond_to do |format|
        format.html do
          render 'errors/404', status: 404, layout: "layouts/error"
        end
        format.all do
          render nothing: true, status: 404
        end
      end
    end

    def render_error(exception = nil)
      call_before_rescue_block
      @exception = exception
      respond_to do |format|
        format.html do
          render 'errors/500', status: 500, layout: 'layouts/error'
        end
        format.all do
          render nothing: true, status: 500
        end
      end
    end

    def call_before_rescue_block
      if defined?(@@before_rescue) && @@before_rescue.is_a?(Proc)
        instance_eval(&@@before_rescue)
      end
    end

  end
end