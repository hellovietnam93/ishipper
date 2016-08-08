class Api::V1::UsersController < Api::BaseController
  before_action :ensure_params_exist
  before_action :find_user, only: :update
  before_action :correct_user, only: :update
  before_action :ensure_params_exist, only: [:index, :update]

  def index
    users = User.near [params[:user][:latitude], params[:user][:longitude]],
      params[:user][:distance]
    users = users.shipper
    if users.any?
      render json: {message: I18n.t("users.messages.get_shipper_success"),
        data: {users: users}, code: 1}, status: 200
    else
      render json: {message: I18n.t("users.messages.get_shipper_fails"),
        data: {}, code: 1}, status: 200
    end
  end

  def update
    if @user.update_with_password user_params
      render json: {message: I18n.t("users.messages.update_success"),
        data: {user: @user}, code: 1}, status: 200
    else
      render json: {message: error_messages(@user.errors.messages),
        data: {}, code: 0}, status: 200
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def find_user
    @user = User.find_by id: params[:id]

    render json: {message: I18n.t("users.messages.user_not_found"),
      data: {}, code: 0}, status: 200 unless @user
  end
end
