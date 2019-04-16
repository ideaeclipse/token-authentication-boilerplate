require 'digest'
# TODO: secret in production doesn't exist
class UserController < ApplicationController
  before_action :is_admin?, only: [:admin, :create_user]
  before_action :validate_login_params, only: [:auth, :admin]
  skip_before_action :auth_user, only: :auth


  #passes username and password, returns authentication token
  def auth
    user = User.find_by_username(params[:username])
    if user and user.password == Digest::SHA256.hexdigest(params[:password])
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
  # Tests admin privileges
  def admin
    render json: {status: "Authorized"}
  end

  # Admin user can create a user account
  def create_user
    temp = User.find_by_username(params[:username])
    if temp.nil?
      user = User.new(username: params[:username], password: Digest::SHA256.hexdigest(params[:password]), is_admin: false)
      user.save
      render json: {status: "Auth"}
    else
      render json: {status: "That username is already taken please try another one"}
    end
  end

  private

  # Validates json params
  def validate_login_params
    unless params[:username].present? and params[:password].present?
      render json: {status: "Missing params"}
    end
  end
end
