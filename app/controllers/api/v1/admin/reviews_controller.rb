module Api
  module V1
    module Admin
      class ReviewsController < BaseController

        # GET /api/v1/admin/reviews
        def index
          reviews = Review.includes(:user, :product).order(created_at: :desc)
          reviews = reviews.where(rating: params[:rating]) if params[:rating].present?

          render json: reviews.map { |r| review_json(r) }, status: :ok
        end

        # DELETE /api/v1/admin/reviews/:id
        def destroy
          review = Review.find_by(id: params[:id])
          return render json: { message: 'Review not found' }, status: :not_found unless review

          review.destroy
          render json: { message: 'Review removed successfully' }, status: :ok
        end

        private

        def review_json(review)
          {
            id:         review.id,
            rating:     review.rating,
            body:       review.body,
            created_at: review.created_at,
            user: {
              id:        review.user.id,
              full_name: review.user.full_name,
              email:     review.user.email
            },
            product: {
              id:   review.product.id,
              name: review.product.name,
              slug: review.product.slug
            }
          }
        end
      end
    end
  end
end
