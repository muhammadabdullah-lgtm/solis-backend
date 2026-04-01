module Api
  module V1
    module Admin
      class BrandsController < BaseController
        before_action :set_brand, only: [:show, :update, :destroy]

        def index
          brands = Brand.order(created_at: :desc)

          render json: brands.as_json(
            only: [:id, :name, :slug, :status, :created_at]
          ), status: :ok
        end

        def show
          render json: @brand.as_json(
            only: [:id, :name, :slug, :status, :created_at, :updated_at]
          ), status: :ok
        end

        def create
          brand = Brand.new(brand_params)

          if brand.save
            render json: {
              message: 'Brand created successfully',
              brand: brand.as_json(only: [:id, :name, :slug, :status])
            }, status: :created
          else
            render json: {
              message: 'Brand creation failed',
              errors: brand.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def update
          if @brand.update(brand_params)
            render json: {
              message: 'Brand updated successfully',
              brand: @brand.as_json(only: [:id, :name, :slug, :status])
            }, status: :ok
          else
            render json: {
              message: 'Brand update failed',
              errors: @brand.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def destroy
          @brand.destroy!
          render json: { message: 'Brand deleted successfully' }, status: :ok
        rescue ActiveRecord::DeleteRestrictionError => e
          render json: {
            message: 'Brand cannot be deleted',
            errors: [e.message]
          }, status: :unprocessable_entity
        end

        private

        def set_brand
          @brand = Brand.find(params[:id])
        end

        def brand_params
          params.require(:brand).permit(:name, :slug, :status)
        end
      end
    end
  end
end