module Spree
  module Admin
    class AdHocOptionTypesController < ResourceController

      before_action :load_product
      before_action :load_available_option_values, only: [:edit]

      def index
        @option_types = @product.ad_hoc_option_types
      end

      def new
        set_available_ad_hoc_option_types
        render layout: false
      end

      def add_option_value
        ad_hoc_option_value = @ad_hoc_option_type.ad_hoc_option_values.new(option_value_id: params[:option_value_id])
        if ad_hoc_option_value.save
          flash[:success] = 'Ad Hoc Option Value Created'
        else
          flash[:error] = 'Error Creating Ad Hoc Option Value'
        end

        redirect_to edit_admin_product_ad_hoc_option_type_url(@ad_hoc_option_type.product, @ad_hoc_option_type)
      end

      def destroy
        # TODO: when removing an option type, we need to check if removing the option type from an
        # associated exclusion causes the exclusion to only have one member.  If so, we'll need to
        # remove the entire exclusion
        if @ad_hoc_option_type.destroy
          flash[:success] = 'Ad Hoc Option Type Deleted'
        else
          flash[:error] = 'Error Deleting Ad Hoc Option Type'
        end

        respond_to do |format|
          format.html { redirect_to admin_product_ad_hoc_option_types_url(@product) }
          format.js { render_js_for_destroy }
        end
      end

      def create
        option_type = Spree::OptionType.find(params[:option_type_id])

        @ad_hoc_option_type.option_type = option_type
        @ad_hoc_option_type.position = option_type.position
        @product.ad_hoc_option_types << @ad_hoc_option_type

        redirect_to edit_admin_product_ad_hoc_option_type_url(@product, @ad_hoc_option_type)
      end

      protected

      def location_after_save
        admin_product_ad_hoc_option_types_url(@ad_hoc_option_type.product)
      end

      private

      def set_available_ad_hoc_option_types
        @available_option_types = OptionType.all.to_a
        selected_option_types = []
        @product.ad_hoc_option_types.each do |option|
          selected_option_types << option.option_type
        end
        @available_option_types.delete_if {|ot| selected_option_types.include? ot}
      end

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
end
