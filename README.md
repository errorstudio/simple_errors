# SimpleErrors - a simple way to rescue errors in Rails applications

On practically every job we rescue errors in the ApplicationController in the same way, so it was time for a gem. This gem rescues from defined error classes (along with the standard Rails ActiveRecordNotFound and RoutingError classes) to either a 404 or 500 error page.

If you need something more complicated than that (e.g. 403 errors), you still need to rescue in ApplicationController. They're not mutually exclusive, though.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_errors'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_errors
    
## Configuration and setup

There's a generator to set up the files you need, and add a mixin in the application controller:

    rails generate simple_errors
    
This will set up:

* /app/views/layouts/error.html.erb - a layout for errors.
* /app/views/errors/500.html.erb - the 500 error page 
* /app/views/errors/404.html.erb - the 404 error page

It also removes the default error pages in /public.

## Configuring `ApplicationController`

After you've run the generator, your Application Controller will look like this:

```
class ApplicationController < ActionController::Base
  include SimpleErrors::Rescue
  # other stuff
end

```

There are a couple of class methods provided by this gem to configure it.
                                                                          
### Rescuing from other classes
If your application raises errors of other types, you might want to rescue to 404 instead of 500. Do that by adding a call to `rescue_with_not_found`, passing one or many classes:
 
```
class ApplicationController < ActionController::Base
  rescue_with_not_found Rooftop::RecordNotFoundError, Rooftop::Rails::AncestorMismatch
  include SimpleErrors::Rescue
  # other stuff
end  
```

### Doing something before rescuing
Sometime you want your error page to render something - for example, call the same method as a before_filter does to get navigation items.

```
class ApplicationController < ActionController::Base
  rescue_with_not_found Rooftop::RecordNotFoundError, Rooftop::Rails::AncestorMismatch
  include SimpleErrors::Rescue
  before_rescue do
    @foo = SomeMenu.find(1234)
  end
end
```

The `before_rescue` block is evaluated in the context of the rendering call, so if you set @foo in the example above it'll be available in your view.

## Contributing

1. Fork it ( https://github.com/errorstudio/simple_errors/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
