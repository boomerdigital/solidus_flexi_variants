require 'deface'

module SolidusFlexiVariants
  module Backend
    class Engine < Rails::Engine

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        puts "---- activating SolidusFlexiVariants Backend engine"
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/overrides/*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare &method(:activate).to_proc

      initializer "spree.flexi_variants.assets.precompile" do |app|
          app.config.assets.precompile += ['spree/backend/orders/flexi_configuration.js']
      end

    end
  end
end
