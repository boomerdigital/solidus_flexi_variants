module SolidusFlexiVariants
  module Frontend
    class Engine < Rails::Engine

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        puts "---- activating SolidusFlexiVariants Frontend engine"
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare &method(:activate).to_proc

      initializer "spree.flexi_variants.assets.precompile" do |app|
          app.config.assets.precompile += ['spree/frontend/solidus_flexi_variants_exclusions.js','spree/backend/orders/flexi_configuration.js'] # ,'spree/frontend/spree-flexi-variants.*' # removed for now until we need the styles
      end
    end
  end
end
