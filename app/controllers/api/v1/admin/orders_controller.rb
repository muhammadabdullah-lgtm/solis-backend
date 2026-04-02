module Api
  module V1
    module Admin
      class OrdersController < BaseController
        before_action :set_order, only: [:show, :update]

        VALID_STATUS_TRANSITIONS = {
          'pending'   => %w[confirmed cancelled],
          'confirmed' => %w[shipped cancelled],
          'shipped'   => %w[delivered],
          'delivered' => [],
          'cancelled' => []
        }.freeze

        # GET /api/v1/admin/orders
        def index
          orders = Order.includes(:user, :order_items)
                        .order(created_at: :desc)

          orders = orders.where(status: params[:status]) if params[:status].present?

          render json: orders.map { |o| order_summary_json(o) }, status: :ok
        end

        # GET /api/v1/admin/orders/:id
        def show
          render json: order_detail_json(@order), status: :ok
        end

        # PATCH /api/v1/admin/orders/:id
        def update
          new_status = params.dig(:order, :status)

          unless new_status.present?
            return render json: { message: 'status is required' }, status: :unprocessable_entity
          end

          unless Order.statuses.key?(new_status)
            return render json: {
              message: 'Invalid status',
              errors: ["Valid statuses: #{Order.statuses.keys.join(', ')}"]
            }, status: :unprocessable_entity
          end

          allowed = VALID_STATUS_TRANSITIONS[@order.status] || []
          unless allowed.include?(new_status)
            return render json: {
              message: 'Invalid status transition',
              errors: ["Cannot move from '#{@order.status}' to '#{new_status}'. Allowed: #{allowed.join(', ').presence || 'none'}"]
            }, status: :unprocessable_entity
          end

          @order.update!(status: new_status)
          render json: {
            message: 'Order status updated successfully',
            order: order_summary_json(@order)
          }, status: :ok
        end

        private

        def set_order
          @order = Order.includes(:user, order_items: :product).find_by(id: params[:id])
          render json: { message: 'Order not found' }, status: :not_found unless @order
        end

        def order_summary_json(order)
          {
            id:          order.id,
            status:      order.status,
            total_price: order.total_price.to_s,
            currency:    order.currency,
            total_items: order.order_items.sum(:quantity),
            created_at:  order.created_at,
            user: {
              id:        order.user.id,
              full_name: order.user.full_name,
              email:     order.user.email
            }
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
            user: {
              id:        order.user.id,
              full_name: order.user.full_name,
              email:     order.user.email
            },
            delivery_address: {
              full_name:   order.full_name,
              phone:       order.phone,
              street:      order.street,
              city:        order.city,
              state:       order.state,
              country:     order.country,
              postal_code: order.postal_code
            },
            items: order.order_items.map { |item| order_item_json(item) }
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
end
