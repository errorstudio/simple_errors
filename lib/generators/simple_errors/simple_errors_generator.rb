class SimpleErrorsGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  desc "This generator adds error page views and layout to your application."
  def copy_layout
    copy_file "error.html.erb", "app/views/layouts/error.html.erb"
  end

  def copy_error_pages
    %w(404.html.erb 500.html.erb).each do |file|
      copy_file file, "app/views/errors/#{file}"
    end
  end

  def include_simple_errors
    inject_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-RUBY
      include SimpleErrors::Rescue
    RUBY
    end
  end

  def remove_default_files
    remove_file 'public/404.html'
    remove_file 'public/500.html'
  end
end