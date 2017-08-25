module SolidusFlexiVariants
    class Engine < Rails::Engine

      initializer "spree.flexi_variants.assets.precompile" do |app|
          app.config.assets.precompile += ['spree/frontend/solidus_flexi_variants_exclusions.js','spree/backend/orders/flexi_configuration.js'] # ,'spree/frontend/spree-flexi-variants.*' # removed for now until we need the styles
      end

  end
end
