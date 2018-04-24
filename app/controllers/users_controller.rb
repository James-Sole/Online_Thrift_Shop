class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    render layout:"login_reg"
  end
  def create
    if new_user.valid?
      session[:user_id]=new_user.id
      return redirect_to products_path
    end
    redirect_to :back, alert: new_user.errors.full_messages
  end
  def show
    if params[:id] == current_user.id.to_s
      ##pass in the proper info for sold sales and purchases
      @user ||=User.find(session[:user_id])
      @Products ||= Product.eager_load(:seller, :buyer).all
      @not_sold ||= Product.eager_load(:seller, :buyer).where(seller_id:params[:id], buyer_id:nil)
      @sold ||= Product.eager_load(:seller, :buyer).where(seller_id:params[:id]).where.not(buyer_id:nil)
      @purchases ||= Product.eager_load(:seller, :buyer).where(buyer_id:params[:id])
      @sold_total ||= Product.eager_load(:seller, :buyer).where(seller_id:params[:id]).where.not(buyer_id:nil).sum(:amount)
      @purchases_total ||= Product.eager_load(:seller, :buyer).where(buyer_id:params[:id]).sum(:amount)
      render layout:"login_reg"
    else
      return redirect_to products_path
    end
  end
  def edit
    p current_user.id
    p params[:id].to_s
    if params[:id] == current_user.id.to_s
      user
      render layout:"login_reg"
    else
      return redirect_to products_path
    end
  end
  def update
    if edit_user.valid?
      return redirect_to products_path
    end
    redirect_to :back, alert: edit_user.errors.full_messages
  end
  private
    helper_method def user
      @user ||= User.find(params[:id])
    end
    helper_method def new_user
      @new_user ||= User.create(user_params)
    end
    helper_method def edit_user
      @new_user ||= User.update(session[:user_id],update_params)
    end

    def user_params
      params.require(:user).permit(:name, :alias, :email, :password, :password_confirmation)
    end

    def update_params
      params.require(:user).permit(:name, :alias, :email)
    end
end
