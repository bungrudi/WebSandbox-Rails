class UserController < ApplicationController
  def login
    session[:username] = params[:username]
    redirect_back(fallback_location: 'store/items')
  end

  def logout
    session[:username] = nil
    redirect_back(fallback_location: 'store/items')
  end
end
