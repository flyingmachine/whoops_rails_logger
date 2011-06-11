class UsersController < ApplicationController
  def index
    raise "exception in index"
  end
  
  def show
    @user = User.find(params[:id])
  end
end
