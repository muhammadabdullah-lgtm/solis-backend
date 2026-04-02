module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_user!
      before_action :set_order, only: [:show, :cancel]

      # GET /api/v1/orders
      def index
        orders = current_user.orders.order(created_at: :desc)
        render json: orders.map { |o| order_summary_json(o) }, status: :ok
      end

      # GET /api/v1/orders/:id
      def show
        render json: order_detail_json(@order), status: :ok
      end

      # POST /api/v1/orders
      def create
        service = Orders::PlaceOrderService.new(
          user:           current_user,
          address_params: address_params
        )

        order = service.call

        if order
          render json: {
            message: 'Order placed successfully',
            order: order_detail_json(order)
          }, status: :created
        else
          render json: {
            message: 'Failed to place order',
            errors: service.errors
          }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/orders/:id/cancel
      def cancel
        unless @order.cancellable?
          return render json: {
            message: 'Order cannot be cancelled',
            errors: ["Only pending orders can be cancelled (current status: #{@order.status})"]
          }, status: :unprocessable_entity
        end

        @order.update!(status: :cancelled)
        render json: { message: 'Order cancelled successfully', order: order_summary_json(@order) }, status: :ok
      end

      private

      def set_order
        @order = current_user.orders.find_by(id: params[:id])
        render json: { message: 'Order not found' }, status: :not_found unless @order
      end

      def address_params
        params.require(:order).permit(
          :full_name, :phone, :street, :city, :state, :country, :postal_code, :notes
        ).to_h.symbolize_keys
      end

      def order_summary_json(order)
        {
          id:          order.id,
          status:      order.status,
          total_price: order.total_price.to_s,
          currency:    order.currency,
          total_items: order.order_items.sum(:quantity),
          created_at:  order.created_at
        }
      end

      def order_detail_json(order)
        {
          id:          order.id,
          status:      order.status,
          total_price: order.total_price.to_s,
          currency:    order.currency,
          notes:       order.notes,
          created_at:  order.created_at,
          updated_at:  order.updated_at,
          delivery_address: {
            full_name:   order.full_name,
            phone:       order.phone,
            street:      order.street,
            city:        order.city,
            state:       order.state,
            country:     order.country,
            postal_code: order.postal_code
          },
          items: order.order_items.includes(:product).map { |item| order_item_json(item) }
        }
      end

      def order_item_json(item)
        {
          id:                item.id,
          quantity:          item.quantity,
          unit_price:        item.unit_price.to_s,
          subtotal:          item.subtotal.to_s,
          product_name:      item.product_name,
          product_sku:       item.product_sku,
          product_image_url: item.product_image_url,
          product: {
            id:   item.product_id,
            slug: item.product.slug
          }
        }
      end
    end
  end
end
