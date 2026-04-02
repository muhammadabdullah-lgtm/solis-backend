class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  before_action :set_default_format


    private

  def set_default_format
    request.format = :json
  end

  

end