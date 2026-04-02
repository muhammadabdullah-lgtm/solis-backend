module Api
  module V1
    class CartsController < ApplicationController
      before_action :authenticate_user!

      def show
        cart = find_or_create_cart
        render json: cart_json(cart), status: :ok
      end

      def destroy
        cart = current_user.cart
        if cart
          cart.cart_items.destroy_all
          render json: { message: 'Cart cleared successfully' }, status: :ok
        else
          render json: { message: 'Cart is already empty' }, status: :ok
        end
      end

      private

      def find_or_create_cart
        current_user.cart || current_user.create_cart!
      end

      def cart_json(cart)
        {
          id: cart.id,
          total_items: cart.total_items,
          total_price: cart.total_price.to_s,
          currency: 'AED',
          items: cart.cart_items.includes(:product).map { |item| cart_item_json(item) }
        }
      end

      def cart_item_json(item)
        {
          id: item.id,
          quantity: item.quantity,
          unit_price: item.product.price.to_s,
          subtotal: (item.product.price * item.quantity).to_s,
          product: {
            id: item.product.id,
            name: item.product.name,
            slug: item.product.slug,
            image_url: item.product.image_url,
            price: item.product.price.to_s,
            compare_at_price: item.product.compare_at_price&.to_s,
            stock_quantity: item.product.stock_quantity,
            in_stock: item.product.in_stock?
          }
        }
      end
    end
  end
end
