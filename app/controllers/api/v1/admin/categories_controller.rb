module Api
  module V1
    module Admin
      class CategoriesController < BaseController
        before_action :set_category, only: [:show, :update, :destroy]

        def index
          categories = Category.includes(:parent).order(created_at: :desc)

          render json: categories.as_json(
            only: [:id, :name, :slug, :status, :parent_id, :created_at],
            include: {
              parent: { only: [:id, :name, :slug] }
            }
          ), status: :ok
        end

        def show
          render json: @category.as_json(
            only: [:id, :name, :slug, :status, :parent_id, :created_at, :updated_at],
            include: {
              parent: { only: [:id, :name, :slug] },
              subcategories: { only: [:id, :name, :slug, :status] }
            }
          ), status: :ok
        end

        def create
          category = Category.new(category_params)

          if category.save
            render json: {
              message: 'Category created successfully',
              category: category.as_json(only: [:id, :name, :slug, :status, :parent_id])
            }, status: :created
          else
            render json: {
              message: 'Category creation failed',
              errors: category.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def update
          if @category.update(category_params)
            render json: {
              message: 'Category updated successfully',
              category: @category.as_json(only: [:id, :name, :slug, :status, :parent_id])
            }, status: :ok
          else
            render json: {
              message: 'Category update failed',
              errors: @category.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def destroy
          @category.destroy!
          render json: { message: 'Category deleted successfully' }, status: :ok
        rescue ActiveRecord::DeleteRestrictionError => e
          render json: {
            message: 'Category cannot be deleted',
            errors: [e.message]
          }, status: :unprocessable_entity
        end

        private

        def set_category
          @category = Category.find(params[:id])
        end

        def category_params
          params.require(:category).permit(:name, :slug, :status, :parent_id)
        end
      end
    end
  end
end