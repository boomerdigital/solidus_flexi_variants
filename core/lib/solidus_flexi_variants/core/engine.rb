module SolidusFlexiVariants
  module Core
    class Engine < Rails::Engine
      engine_name 'solidus_flexi_variants'

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        puts "---- activating SolidusFlexiVariants Core engine"
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare &method(:activate).to_proc

      initializer "spree.flexi_variants.preferences", after: "spree.environment" do |app|
        SolidusFlexiVariants::Config = Spree::FlexiVariantsConfiguration.new
      end

      initializer "spree.flexi_variants.register.line_item_comparision_hooks" do |app|
        Spree::Order.register_line_item_comparison_hook(:product_customizations_match)
        Spree::Order.register_line_item_comparison_hook(:ad_hoc_option_values_match)
      end

      initializer "spree.flexi_variants.register.calculators" do |app|
        app.config.spree.calculators.add_class('product_customization_types') unless app.config.spree.calculators.respond_to?(:product_customization_types)
        app.config.spree.calculators.product_customization_types.concat([
                                                                      Spree::Calculator::Engraving,
                                                                      Spree::Calculator::AmountTimesConstant,
                                                                      Spree::Calculator::ProductArea,
                                                                      Spree::Calculator::CustomizationImage,
                                                                      Spree::Calculator::NoCharge
                                                                     ])
      end
    end
  end
end
