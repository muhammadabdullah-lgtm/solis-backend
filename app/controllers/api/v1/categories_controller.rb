module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        categories = Category.active
                             .includes(subcategories: :subcategories)
                             .where(parent_id: nil)
                             .order(:name)

        render json: {
          categories: categories.map { |category| category_payload(category) }
        }, status: :ok
      end

      private

      def category_payload(category)
        {
          id:            category.id,
          name:          category.name,
          slug:          category.slug,
          subcategories: category.subcategories.select(&:active?).map do |sub|
            {
              id:            sub.id,
              name:          sub.name,
              slug:          sub.slug,
              parent_id:     sub.parent_id,
              subcategories: sub.subcategories.select(&:active?).map do |subsub|
                {
                  id:        subsub.id,
                  name:      subsub.name,
                  slug:      subsub.slug,
                  parent_id: subsub.parent_id
                }
              end
            }
          end
        }
      end
    end
  end
end