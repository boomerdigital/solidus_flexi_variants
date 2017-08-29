module Spree
  module Admin
    class AdHocVariantExclusionsController < ResourceController

      before_action :load_product

      def create
        return unless params["ad_hoc_option_type"]

        params["ad_hoc_option_type"].each_pair do |otid, ovid|
          next if ovid.empty?
          eov = ExcludedAdHocOptionValue.create(ad_hoc_variant_exclusion: @ad_hoc_variant_exclusion, ad_hoc_option_value_id: ovid)
        end
        @ad_hoc_variant_exclusion.product = @product
        if @ad_hoc_variant_exclusion.save
          flash[:success] = 'Ad Hoc Variant Exclusion was created'
        else
          flash[:error] = 'Error in creating Ad Hoc Variant Exclusion'
        end

        redirect_to admin_product_ad_hoc_variant_exclusions_path(@product)
      end

      def destroy
        if @ad_hoc_variant_exclusion.destroy
          flash[:success] = I18n.t("spree.notice_messages.ad_hoc_variant_exclusion_removed")
        else
          flash[:error] = 'Error Deleting Ad Hoc Variant Exclusion'
        end

        respond_to do |format|
          format.html { redirect_to admin_product_ad_hoc_variant_exclusions_path(@product) }
          format.js { render_js_for_destroy }
        end
      end

      private

      def load_product
        @product = if params[:product_id].present?
          Product.friendly.find(params[:product_id])
        else
          @ad_hoc_variant_exclusion.product
        end
      end

    end
  end
end
