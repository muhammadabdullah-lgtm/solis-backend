module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: {
            message: 'Signed in successfully',
            user: user_payload(resource)
          }, status: :ok
        end

        def respond_to_on_destroy
          auth_header = request.headers['Authorization']

          if auth_header.present?
            render json: { message: 'Signed out successfully' }, status: :ok
          else
            render json: { message: 'No active session found' }, status: :unauthorized
          end
        end

        def user_payload(user)
          {
            id: user.id,
            full_name: user.full_name,
            email: user.email,
            role: user.role,
            auth_source: user.auth_source
          }
        end
      end
    end
  end
end