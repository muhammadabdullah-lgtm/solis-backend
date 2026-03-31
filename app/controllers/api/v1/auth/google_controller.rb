module Api
  module V1
    module Auth
      class GoogleController < ApplicationController


        
        def create
          result = Auth::GoogleSignInService.new(params[:id_token]).call

          if result.success?
            response.set_header('Authorization', "Bearer #{result.token}")

            render json: {
              message: 'Google authentication successful',
              token: result.token,
              user: user_payload(result.user)
            }, status: :ok
          else
            render json: {
              message: result.error
            }, status: result.status
          end
        end

        private

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