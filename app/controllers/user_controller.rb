class UserController < ApplicationController
  def login
    session[:username] = params[:username]
    flash[:login_successful] = true
    redirect_back(fallback_location: 'store/items')
  end

  def logout
    session[:username] = nil
    redirect_back(fallback_location: 'store/items')
  end
end
