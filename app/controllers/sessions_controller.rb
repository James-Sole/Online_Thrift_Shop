class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  def new
    render layout:"login_reg"
  end

  def create
    errors = []
    @user = User.find_by(email: params[:email])
    if @user
      if @user.authenticate(params[:password])
        session[:user_id]= @user.id

        return redirect_to products_path
      else
        errors << 'Invalid password/email.'
      end
    else
      errors << 'No corrispinding account.'
    end
    redirect_to :back, alert: errors
  end

  def destroy
    session.delete :user_id if session.key? 'user_id'
    redirect_to new_login_path
  end
end
