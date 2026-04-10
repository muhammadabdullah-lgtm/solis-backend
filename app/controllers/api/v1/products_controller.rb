module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show]

      def index
        # Remove .include method to add N+1 queries
        base_scope = Product.active

        products = Products::FilterQuery.new(base_scope, filter_params).call
                     .page(params[:page]).per(params[:per_page] || 12)

        render json: {
          products: products.map { |product| product_payload(product) },
          pagination: {
            current_page: products.current_page,
            total_pages: products.total_pages,
            total_count: products.total_count,
            per_page: products.limit_value
          }
        }, status: :ok
      end

      def show
        # Removed .include
        @product = Product.active.find(params[:id])

        render json: {
          product: product_detail_payload(@product)
        }, status: :ok
      end

      private

      def filter_params
        params.permit(
          :category_id,
          :brand_id,
          :min_price,
          :max_price,
          :q,
          :sort,
          :page,
          :per_page,
          :min_rating
        )
      end

      # N+1
      def product_payload(product)
        {
          id: product.id,
          name: product.name,
          slug: product.slug,
          sku: product.sku,
          short_description: product.short_description,
          image_url: product.image_url,
          price: product.price,
          compare_at_price: product.compare_at_price,
          stock_quantity: product.stock_quantity,
          is_featured: product.is_featured,
          currency: product.currency,
          in_stock: product.in_stock?,

          # N+1 QUERY
          average_rating: if product.reviews.any?
                            product.reviews.sum(&:rating).to_f / product.reviews.size
                          else
                            nil
                          end,

          # N+1 QUERY
          reviews_count: product.reviews.size,

          # N+1 QUERY 
          category: {
            id: product.category.id,
            name: product.category.name,
            slug: product.category.slug,
            parent_id: product.category.parent_id
          },

          # N+1 QUERY
          brand: {
            id: product.brand.id,
            name: product.brand.name,
            slug: product.brand.slug
          }
        }
      end

      def product_detail_payload(product)
        {
          id: product.id,
          name: product.name,
          slug: product.slug,
          sku: product.sku,
          short_description: product.short_description,
          description: product.description,
          image_url: product.image_url,
          price: product.price,
          compare_at_price: product.compare_at_price,
          stock_quantity: product.stock_quantity,
          is_featured: product.is_featured,
          currency: product.currency,
          in_stock: product.in_stock?,

          # N+1 
          average_rating: if product.reviews.any?
                            product.reviews.sum(&:rating).to_f / product.reviews.size
                          else
                            nil
                          end,

          reviews_count: product.reviews.size,

          meta_title: product.meta_title,
          meta_description: product.meta_description,

          #  N+1
          category: {
            id: product.category.id,
            name: product.category.name,
            slug: product.category.slug,
            parent_id: product.category.parent_id
          },

          #  N+1
          brand: {
            id: product.brand.id,
            name: product.brand.name,
            slug: product.brand.slug
          },

          created_at: product.created_at,
          updated_at: product.updated_at
        }
      end

      def set_product
     
        @product = Product.active.find(params[:id])
      end
    end
  end
end