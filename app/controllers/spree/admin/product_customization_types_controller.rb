module Spree
  class Admin::ProductCustomizationTypesController < Admin::ResourceController
    before_action :load_product, only: [:selected, :available, :remove, :select]
    before_action :load_calculators, only: [:new, :edit]

    # product related changes

    def selected
      @product_customization_types = @product.product_customization_types
    end

    def load_calculators
      @calculators = ProductCustomizationType.calculators.sort_by(&:name)
    end

    def available
      set_available_product_customization_types
      render layout: false
    end

    def remove
      @product.product_customization_types.delete(@product_customization_type)
      if @product.save
        flash[:success] = I18n.t("spree.notice_messages.product_customization_type_removed")
      else
        flash[:error] = 'Error in deleting Customization Type'
      end

      redirect_to selected_admin_product_product_customization_types_url(@product)
    end


    # AJAX method for selecting an existing option type and associating with the current product
    def select
      @product.product_customization_types << @product_customization_type

      @product.save

      @product_customization_types = @product.product_customization_types
    end

    # For general changes

    def destroy
      if @product_customization_type.destroy
        flash[:success] = 'Product Customization Type was Deleted'
      else
        flash[:error] = 'Error Deleting Product Customization Type'
      end

      respond_with(@product_customization_type) do |format|
        format.html { redirect_to admin_product_customization_types_path }
        format.js { render_js_for_destroy }
      end
    end

    def edit
      # Is this an edit immediately after create?  If so, need to create
      # calculator-appropriate default options
      if @product_customization_type.customizable_product_options.empty?
        if !@product_customization_type.calculator.nil?

          opts = @product_customization_type.calculator.create_options
          @product_customization_type.customizable_product_options.concat opts if opts

          # for each mandatory input type
          #        @product_customization_type.calculator.required_fields.each_pair do |key, val|
          #          cpo= CustomizableProductOption.create(name: key, presentation: key.titleize, is_required: true,data_type: val)
          #          @product_customization_type.customizable_product_options << cpo
          #        end
        end
      end
    end

    private

    def load_product
      @product = Product.friendly.find(params[:product_id])
    end

    def set_available_product_customization_types
      @available_product_customization_types = ProductCustomizationType.all.to_a
      selected_product_customization_types = []
      @product.product_customization_types.each do |pct|
        selected_product_customization_types << pct
      end
      @available_product_customization_types.delete_if {|pct| selected_product_customization_types.include? pct}
    end
  end
end
