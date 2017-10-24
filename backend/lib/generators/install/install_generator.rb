module Generators
  class InstallGenerator < Rails::Generators::Base

    def add_javascripts
      append_file "vendor/assets/javascripts/spree/backend/all.js", "//= require spree/backend/solidus_flexi_variants\n"
    end
    
  end
end