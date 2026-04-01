module Api
  module V1
    class BrandsController < ApplicationController
      def index
        brands = Brand.active.order(:name)

        render json: {
          brands: brands.map do |brand|
            {
              id: brand.id,
              name: brand.name,
              slug: brand.slug
            }
          end
        }, status: :ok
      end
    end
  end
end