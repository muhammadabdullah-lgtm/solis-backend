module Api
  module V1
    class CartItemsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_cart
      before_action :set_cart_item, only: [:update, :destroy]

      # POST /api/v1/cart/items
      def create
        product = Product.active.find_by(id: cart_item_params[:product_id])

        unless product
          return render json: { message: 'Product not found or unavailable' }, status: :not_found
        end

        existing_item = @cart.cart_items.find_by(product_id: product.id)

        if existing_item
          new_quantity = existing_item.quantity + cart_item_params[:quantity].to_i
          if existing_item.update(quantity: new_quantity)
            render json: { message: 'Cart updated successfully', item: cart_item_json(existing_item) }, status: :ok
          else
            render json: { message: 'Failed to update cart', errors: existing_item.errors.full_messages }, status: :unprocessable_entity
          end
        else
          item = @cart.cart_items.new(cart_item_params)
          if item.save
            render json: { message: 'Item added to cart', item: cart_item_json(item) }, status: :created
          else
            render json: { message: 'Failed to add item', errors: item.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      # PATCH /api/v1/cart/items/:id
      def update
        if @cart_item.update(quantity: cart_item_params[:quantity])
          render json: { message: 'Item updated successfully', item: cart_item_json(@cart_item) }, status: :ok
        else
          render json: { message: 'Failed to update item', errors: @cart_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/cart/items/:id
      def destroy
        @cart_item.destroy
        render json: { message: 'Item removed from cart' }, status: :ok
      end

      private

      def set_cart
        @cart = current_user.cart || current_user.create_cart!
      end

      def set_cart_item
        @cart_item = @cart.cart_items.find_by(id: params[:id])
        unless @cart_item
          render json: { message: 'Item not found in cart' }, status: :not_found
        end
      end

      def cart_item_params
        params.require(:cart_item).permit(:product_id, :quantity)
      end

      def cart_item_json(item)
        item.reload
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
            stock_quantity: item.product.stock_quantity,
            in_stock: item.product.in_stock?
          }
        }
      end
    end
  end
end
