module Spree
  class Admin::VariantConfigurationsController < Admin::BaseController
    helper 'spree/products'
    
    def show
      @variant = Variant.find(params[:variant_id])

      respond_to do |wants|
        wants.js { render '/spree/shared/variant_configurations/configure' }
      end
    end

    def create
      @variant = Variant.find(params[:variant_id])

      respond_to do |wants|
        wants.js { render '/spree/shared/variant_configurations/configure' }
      end
    end

  end
end
