class UsersController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :user_params, only: [:edit, :update]
  skip_before_action :verify_authenticity_token, only: :token

  def mypage
    @user = current_user
  end

  def edit
  end

  def reported_user
  end

  def select_certification
  end

  def submit_student_card
    current_user.certification_state = 'waiting'
    current_user.update!(get_student_card_image)
  end

  def submit_student_email
    email_certification = EmailCertification.new(current_user, params)
    email_certification.exec
  end

  def confirm_email
    current_user.approved! if current_user.certification_token == params.permit(:token)[:token]
    redirect_to root_path(notice: '인증이 성공적으로 이루어졌습니다.');
  end

  def token
    Rails.logger.info('generate a new token')
    user = User.find(params[:id])
    user.update_attributes!(device_token: params[:token], device_type: params[:device_type])
    head 200
  end

  def check_email
    email = params[:email] if params[:email].present?
    already_exist = User.find_by(email: email).present?
    format_wrong = (email =~ /\A[^@\s]+@[^@\s]+\z/) != 0
    result = (already_exist || format_wrong)  ? 0 : 1
    render json: {result: result}
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :thumbnail, :address1, :address2, :zipcode)
  end

  def get_student_card_image
    params.require(:user).permit(:student_card_image)
  end
end
