class ProductsController < ApplicationController
  def index
    @Products ||= Product.eager_load(:seller, :buyer).where(buyer_id:nil)
    render layout:"login_reg"
  end
  def create
		@Product ||= Product.create(item:params[:item], amount:params[:amount] ,seller_id:session[:user_id])
		if @Product.valid?
			return redirect_to user_path(session[:user_id])
		end

		flash[:alert] = @Product.errors.full_messages
		# p @secret.errors.full_messages
		return redirect_to user_path(session[:user_id])
	end

  def update
		@Product ||= Product.update(params[:id], buyer_id:session[:user_id])
		if @Product.valid?
			return redirect_to user_path(session[:user_id])
		end

		flash[:alert] = @Product.errors.full_messages
		# p @secret.errors.full_messages
		return redirect_to user_path(session[:user_id])
	end

	def destroy
		@this_product = Product.find_by(id: params[:id])
		if session[:user_id] == @this_product.user.id
			@this_product.destroy
			return redirect_to user_path(session[:user_id])
		else
			flash[:alert] = ["That is not your product to destroy."]
			return redirect_to user_path(session[:user_id])
		end
	end
end
