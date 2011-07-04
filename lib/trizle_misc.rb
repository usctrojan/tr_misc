
require 'rails'
require 'action_controller'

module TrizleMisc
  class Engine < Rails::Engine
    # Put initializers and other engine-related things here, eg:
    #
    # initializer "static assets" do |app|
    #   app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    # end
    #

    # to include app/helpers stuff

    initializer "trizle setup files" do |app|
      # make it available in controllers
      ActionController::Base.class_eval do
        include TrizleMiscHelper
      end

      # make it available in views
      ActionView::Base.class_eval do
        include TrizleMiscHelper
      end
    end
  end

  # This is used in Rakefile.  Adjust as you see fit.
  Version = '1.0.0'


  # to extend models (e.g. if you want to put a user model inside your app)
  def self.root
    File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

  def self.models_dir
    "#{root}/app/models"
  end

end