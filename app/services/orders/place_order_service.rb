module Orders
  class PlaceOrderService
    attr_reader :errors

    def initialize(user:, address_params:)
      @user           = user
      @address_params = address_params
      @errors         = []
    end

    def call
      cart = @user.cart

      unless cart&.cart_items&.exists?
        @errors << 'Cart is empty'
        return nil
      end

      cart_items = cart.cart_items.includes(:product)

      return nil unless validate_cart_items(cart_items)

      order = nil

      ActiveRecord::Base.transaction do
        order = create_order(cart_items)
        decrement_stock(cart_items)
        cart.cart_items.destroy_all
      end

      order
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
      nil
    end

    private

    def validate_cart_items(cart_items)
      cart_items.each do |item|
        product = item.product

        unless product.active?
          @errors << "\"#{product.name}\" is no longer available"
          return false
        end

        if item.quantity > product.stock_quantity
          @errors << "\"#{product.name}\" only has #{product.stock_quantity} units in stock"
          return false
        end
      end

      true
    end

    def create_order(cart_items)
      total = cart_items.sum { |item| item.product.price * item.quantity }

      order = @user.orders.create!(
        status:      :delivered,
        total_price: total,
        currency:    'AED',
        **@address_params
      )

      cart_items.each do |item|
        product = item.product
        order.order_items.create!(
          product:           product,
          product_name:      product.name,
          product_sku:       product.sku,
          product_image_url: product.image_url,
          unit_price:        product.price,
          quantity:          item.quantity,
          subtotal:          product.price * item.quantity
        )
      end

      order
    end

    def decrement_stock(cart_items)
      cart_items.each do |item|
        item.product.decrement!(:stock_quantity, item.quantity)
      end
    end
  end
end
