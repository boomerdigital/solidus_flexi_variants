Spree::OrdersController.class_eval do

  include ProductCustomizations
  include AdHocUtils

  before_action :set_option_params_values, only: [:populate]

  # is there a better way to make sure options are passed into add order contents?
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(variant, quantity, params[:options])
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = I18n.t(:please_enter_reasonable_quantity, scope: :spree)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(order) do |format|
        format.html { redirect_to cart_path }
      end
    end
  end

  private

  def set_option_params_values
    params[:options] ||= {}
    params[:options][:ad_hoc_option_values] = ad_hoc_option_value_ids
    params[:options][:product_customizations] = product_customizations
    params[:options][:customization_price] = params[:customization_price] if params[:customization_price]
  end

end
