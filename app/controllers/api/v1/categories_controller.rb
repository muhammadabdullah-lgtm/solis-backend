module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        categories = Category.active.includes(:subcategories).where(parent_id: nil).order(:name)

        render json: {
          categories: categories.map { |category| category_payload(category) }
        }, status: :ok
      end

      private

      def category_payload(category)
        {
          id: category.id,
          name: category.name,
          slug: category.slug,
          subcategories: category.subcategories.active.map do |subcategory|
            {
              id: subcategory.id,
              name: subcategory.name,
              slug: subcategory.slug,
              parent_id: subcategory.parent_id
            }
          end
        }
      end
    end
  end
end