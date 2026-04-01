module Api
  module V1
    module Admin
      class ProductsController < BaseController
        before_action :set_product, only: [:show, :update, :destroy]

        def index
          products = Product.includes(:category, :brand).order(created_at: :desc)

          render json: products.as_json(
            only: [
              :id, :name, :slug, :sku, :price, :compare_at_price, :cost_price,
              :stock_quantity, :status, :is_featured, :currency, :created_at
            ],
            include: {
              category: { only: [:id, :name, :slug, :parent_id] },
              brand: { only: [:id, :name, :slug] }
            }
          ), status: :ok
        end

        def show
          render json: @product.as_json(
            only: [
              :id, :name, :slug, :sku, :short_description, :description,
              :price, :compare_at_price, :cost_price, :stock_quantity,
              :status, :is_featured, :currency, :meta_title, :meta_description,
              :category_id, :brand_id, :created_at, :updated_at
            ],
            include: {
              category: { only: [:id, :name, :slug, :parent_id] },
              brand: { only: [:id, :name, :slug] }
            }
          ), status: :ok
        end

        def create
          product = Product.new(product_params)

          if product.save
            render json: {
              message: 'Product created successfully',
              product: product.as_json(
                only: [
                  :id, :name, :slug, :sku, :price, :stock_quantity,
                  :status, :is_featured, :currency, :category_id, :brand_id
                ]
              )
            }, status: :created
          else
            render json: {
              message: 'Product creation failed',
              errors: product.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def update
          if @product.update(product_params)
            render json: {
              message: 'Product updated successfully',
              product: @product.as_json(
                only: [
                  :id, :name, :slug, :sku, :price, :stock_quantity,
                  :status, :is_featured, :currency, :category_id, :brand_id
                ]
              )
            }, status: :ok
          else
            render json: {
              message: 'Product update failed',
              errors: @product.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def destroy
          @product.update!(status: :archived)
          render json: { message: 'Product archived successfully' }, status: :ok
        end

        private

        def set_product
          @product = Product.includes(:category, :brand).find(params[:id])
        end

       def product_params
  params.require(:product).permit(
    :name,
    :slug,
    :sku,
    :short_description,
    :description,
    :image_url,
    :category_id,
    :brand_id,
    :price,
    :compare_at_price,
    :cost_price,
    :stock_quantity,
    :status,
    :is_featured,
    :currency,
    :meta_title,
    :meta_description
  )
end
      end
    end
  end
end