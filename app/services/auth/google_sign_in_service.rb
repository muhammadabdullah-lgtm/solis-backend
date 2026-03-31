module Auth
  class GoogleSignInService
    Result = Struct.new(:success?, :user, :token, :error, :status)

    def initialize(id_token)
      @id_token = id_token
    end

    def call
      return failure('id_token is required', :unprocessable_entity) if @id_token.blank?

      payload = verify_google_id_token
      return failure('Invalid Google token', :unauthorized) unless payload

      user = find_or_create_user(payload)
      token = generate_token(user)

      Result.new(true, user, token, nil, :ok)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.record.errors.full_messages.join(', '), :unprocessable_entity)
    rescue KeyError => e
      failure(e.message, :unprocessable_entity)
    rescue StandardError => e
      failure(e.message, :internal_server_error)
    end

    private

    attr_reader :id_token

    def verify_google_id_token
      Google::Auth::IDTokens.verify_oidc(
        id_token,
        aud: ENV.fetch('GOOGLE_CLIENT_ID')
      )
    rescue StandardError
      nil
    end

    def find_or_create_user(payload)
      email = payload['email']
      full_name = payload['name'].presence || 'Google User'

      user = User.find_by(email: email)

      if user.present?
        update_existing_user(user, full_name)
      else
        create_google_user(email, full_name)
      end
    end

    def update_existing_user(user, full_name)
      updates = {}
      updates[:full_name] = full_name if user.full_name.blank?
      updates[:auth_source] = :google unless user.google?

      user.update!(updates) if updates.any?
      user
    end

    def create_google_user(email, full_name)
      User.create!(
        full_name: full_name,
        email: email,
        password: Devise.friendly_token[0, 20],
        auth_source: :google,
        role: :user
      )
    end

    def generate_token(user)
      Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    end

    def failure(message, status)
      Result.new(false, nil, nil, message, status)
    end
  end
end