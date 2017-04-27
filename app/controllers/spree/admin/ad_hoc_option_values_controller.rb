module Spree
  class Admin::AdHocOptionValuesController < Admin::ResourceController
    def update_positions
      params[:positions].each do |id, index|
        AdHocOptionValue.where(id: id).update_all(position: index)
      end

      respond_to do |format|
        format.js  { render text: 'Ok' }
      end
    end

    def destroy
      ad_hoc_option_value = AdHocOptionValue.find(params[:id])
      if ad_hoc_option_value.destroy
        flash[:success] = 'Ad Hoc Option Value Deleted'
      else
        flash[:success] = 'Error Deleting Ad Hoc Option Value'
      end

      respond_with(ad_hoc_option_value) do |format|
        format.html { redirect_to edit_admin_product_ad_hoc_option_type_path(
        ad_hoc_option_value.ad_hoc_option_type.product_id,
        ad_hoc_option_value.ad_hoc_option_type_id) }
        format.js { render_js_for_destroy }
      end
    end

    def location_after_save
      selected_admin_product_ad_hoc_option_types_url(ad_hoc_option_value.ad_hoc_option_type.product)
    end
  end
end
