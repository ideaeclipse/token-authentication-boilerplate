# TODO: secret in production doesn't exist
class UserController < ApplicationController
  before_action :validate_login_params, only: :auth
  before_action :is_admin?, only: :admin
  skip_before_action :auth_user, only: :auth


  #passes username and password, returns authentication token
  def auth
    user = User.find_by_username(params[:username])
    if user and user.password == params[:password]
      user.token = JsonWebToken.encode(user_id: user.id, username: params[:username], user_password: params[:password], nonce: Random.rand(0..1000))
      user.save
      render json: {token: user.token}
    else
      render json: {status: "Invalid login"}
    end
  end

  #test method that will only execute if the user passed a valid auth token
  def test
    render json: {status: "Authorized"}
  end

  #only admin users can call endpoint
  def admin
    render json: {status: "Authorized"}
  end

  private

  # Validates json params
  def validate_login_params
    unless params[:username].present? and params[:password].present?
      render json: {status: "Missing params"}
    end
  end
end
