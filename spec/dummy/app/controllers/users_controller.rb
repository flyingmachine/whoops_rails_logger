class UsersController < ApplicationController
  def index
    session[:session_test] = "abra"
    raise "exception in index"
  end
  
  def show
    @user = User.find(params[:id])
  end
end
