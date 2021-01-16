module SolidusFlexiVariants
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace Spree
    engine_name 'solidus_flexi_variants'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.flexi_variants.preferences", after: "spree.environment" do |app|
      require "spree/flexi_variants_configuration"

      SolidusFlexiVariants::Config = Spree::FlexiVariantsConfiguration.new
    end

    initializer "spree.flexi_variants.assets.precompile" do |app|
      app.config.assets.precompile += ['spree/frontend/solidus_flexi_variants_exclusions.js','spree/backend/orders/flexi_configuration.js'] # ,'spree/frontend/spree-flexi-variants.*' # removed for now until we need the styles
    end

    initializer "spree.flexi_variants.register.calculators" do |app|
      app.config.spree.calculators.singleton_class.add_class_set('product_customization_types') unless app.config.spree.calculators.respond_to?(:product_customization_types)
      app.config.spree.calculators.product_customization_types.concat([
        "Spree::Calculator::Engraving",
        "Spree::Calculator::AmountTimesConstant",
        "Spree::Calculator::ProductArea",
        "Spree::Calculator::CustomizationImage",
        "Spree::Calculator::NoCharge"
      ])
    end
  end
end
