module Api
  module V1
    class ReviewsController < ApplicationController
      before_action :set_product
      before_action :authenticate_user!, only: [:create, :update, :destroy]
      before_action :set_own_review, only: [:update, :destroy]

      # GET /api/v1/products/:product_id/reviews
      def index
        reviews = @product.reviews
                          .includes(:user)
                          .order(created_at: :desc)

        render json: {
          average_rating: @product.reviews.average(:rating)&.round(1),
          reviews_count:  @product.reviews.count,
          reviews:        reviews.map { |r| review_json(r) }
        }, status: :ok
      end

      # POST /api/v1/products/:product_id/reviews
      def create
        review = @product.reviews.new(review_params.merge(user: current_user))

        if review.save
          render json: { message: 'Review submitted successfully', review: review_json(review) }, status: :created
        else
          render json: { message: 'Failed to submit review', errors: review.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/products/:product_id/reviews/:id
      def update
        if @review.update(review_params)
          render json: { message: 'Review updated successfully', review: review_json(@review) }, status: :ok
        else
          render json: { message: 'Failed to update review', errors: @review.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/products/:product_id/reviews/:id
      def destroy
        @review.destroy
        render json: { message: 'Review deleted successfully' }, status: :ok
      end

      private

      def set_product
        @product = Product.active.find_by(id: params[:product_id])
        render json: { message: 'Product not found' }, status: :not_found unless @product
      end

      def set_own_review
        @review = current_user.reviews.find_by(id: params[:id], product_id: @product.id)
        render json: { message: 'Review not found' }, status: :not_found unless @review
      end

      def review_params
        params.require(:review).permit(:rating, :body)
      end

      def review_json(review)
        {
          id:         review.id,
          rating:     review.rating,
          body:       review.body,
          created_at: review.created_at,
          updated_at: review.updated_at,
          user: {
            id:        review.user.id,
            full_name: review.user.full_name
          }
        }
      end
    end
  end
end
