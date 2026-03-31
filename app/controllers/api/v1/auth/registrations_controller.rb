module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              message: 'Signed up successfully',
              user: user_payload(resource)
            }, status: :created
          else
            render json: {
              message: 'Sign up failed',
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def sign_up_params
          params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
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