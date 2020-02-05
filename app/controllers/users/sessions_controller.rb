class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user != nil && @user.has_no_password?
      respond_to do |format|
        format.html{ redirect_to new_user_session_path , notice: "You cannot sign in without a password. Please check
                                                                  our email for how to set a password."}
      end
      @user.send_confirmation_instructions
    else
      super
    end
  end
end
