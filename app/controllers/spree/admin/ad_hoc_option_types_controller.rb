module Spree
  class Admin::AdHocOptionTypesController < Admin::ResourceController

    before_action :load_product
    before_action :load_available_option_values, only: [:edit]

    def selected
      @option_types = @product.ad_hoc_option_types
    end

    def add_option_value
      @ad_hoc_option_type.ad_hoc_option_values.create!(option_value_id: params[:option_value_id])
      redirect_to edit_admin_product_ad_hoc_option_type_url(@ad_hoc_option_type.product, @ad_hoc_option_type)
    end

    def destroy
      # TODO: when removing an option type, we need to check if removing the option type from an
      # associated exclusion causes the exclusion to only have one member.  If so, we'll need to
      # remove the entire exclusion
      @product = @ad_hoc_option_type.product
      if @ad_hoc_option_type.destroy
        flash[:success] = 'Ad Hoc Option Type Deleted'
      else
        flash[:success] = 'Error Deleting Ad Hoc Option Type'
      end

      respond_with(@variant) do |format|
        format.html { redirect_to selected_admin_product_ad_hoc_option_types_url(@product) }
        format.js { render_js_for_destroy }
      end
    end

    protected

    def location_after_save
      selected_admin_product_ad_hoc_option_types_url(@ad_hoc_option_type.product)
    end

    private
    def load_product
      if params[:product_id].present?
        @product = Spree::Product.friendly.find(params[:product_id])
      else
        @product = @ad_hoc_option_type.product
      end
    end

    def load_available_option_values
      @available_option_values = @ad_hoc_option_type.option_type.option_values - @ad_hoc_option_type.ad_hoc_option_values.map(&:option_value)
    end
  end
end
