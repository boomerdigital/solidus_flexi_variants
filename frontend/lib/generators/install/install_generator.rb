module Generators
  class InstallGenerator < Rails::Generators::Base
    class_option :auto_run_migrations, type: :boolean, default: false

    def add_javascripts
      append_file "vendor/assets/javascripts/spree/frontend/all.js", "//= require spree/frontend/solidus_flexi_variants\n"
    end
    
  end
end

