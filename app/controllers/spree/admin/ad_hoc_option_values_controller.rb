module Spree
  module Admin
    class AdHocOptionValuesController < ResourceController

      before_action :load_product, except: [:destroy]
      before_action :load_ad_hoc_option_type, except: [:destroy]


      def destroy
        ad_hoc_option_value = AdHocOptionValue.find(params[:id])
        if ad_hoc_option_value.destroy
          flash[:success] = 'Ad Hoc Option Value Deleted'
        else
          flash[:error] = 'Error Deleting Ad Hoc Option Value'
        end

        respond_with(ad_hoc_option_value) do |format|
          format.html { redirect_to edit_admin_product_ad_hoc_option_type_path(
                          ad_hoc_option_value.ad_hoc_option_type.product_id,
          ad_hoc_option_value.ad_hoc_option_type_id) }
          format.js { render_js_for_destroy }
        end
      end

      private

      def location_after_save
        admin_product_ad_hoc_option_types_url(ad_hoc_option_value.ad_hoc_option_type.product)
      end

      def load_product
        @product =  Spree::Product.friendly.find(params[:product_id])
      end

      def load_ad_hoc_option_type
        @ad_hoc_option_type = Spree::AdHocOptionType.find(params[:ad_hoc_option_type_id])
      end
    end
  end
end
