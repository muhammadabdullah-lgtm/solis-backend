module Api
  module V1
    module Admin
      class BaseController < ApplicationController
        before_action :authenticate_user!
        before_action :authorize_admin!

        private

        def authorize_admin!


          Rails.logger.debug "This is logger #{current_user}"

          return if current_user&.admin?

          render json: { message: 'Access denied' }, status: :forbidden
        end
      end
    end
  end
end