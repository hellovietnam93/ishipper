class Api::V1::InvoicesController < Api::BaseController
  before_action :ensure_params_exist, only: :index

  def index
    invoices = Invoice.near [params[:user][:latitude], params[:user][:longitude]],
      params[:user][:distance]
    invoices = invoices.init
    if invoices.any?
      render json: {message: I18n.t("invoices.messages.get_invoices_success"),
        data: {invoices: invoices}, code: 1}, status: 200
    else
      render json: {message: I18n.t("invoices.messages.get_invoices_fails"),
        data: {}, code: 1}, status: 200
    end
  end

  private
  def ensure_params_exist
    if params[:user].nil? || params[:user][:latitude].blank? ||
      params[:user][:longitude].blank? || params[:user][:distance].blank?
      render json: {message: I18n.t("api.missing_params"), data: {}, code: 0},
        status: 422
    end
  end
end
