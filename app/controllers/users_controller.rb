class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,   only: :destroy
  #we define correct_user in order to not have to keep definding @user = User.find(params[:id])
  #This also helps so that we mak sure users can edit other users by following links such as
  # user/1/edit, now they are able to edit the 1st user, rather than themself


  attr_accessor :bio


  #following section
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  #following section

  #if the user is the user trying to access page :id, and they do not have the same :id
  #they will be redirected to root_url, unless they are the current_user

  def index
    @users = User.paginate(page: params[:page])
  end
  #once included, paginate method can be used to link search results, rather
  #than giving the computer all of the results, filtered in 30 at a time.
  #found information at https://github.com/mislav/will_paginate

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost  = current_user.microposts.build

  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email for details on activating your account"
      redirect_to root_url
    else
      render 'new'
    end
  end
  #Created a new user with the user_params which come from the request.
  #we manipulate the params to permit some variables assigned to the user
  #and it must require user class. as seen below params.require(:user).permit(variables)
  #So imagine it like hash => [array of variables]

  def edit

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated profile"
      redirect_to @user
    else
      render 'edit'
    end
  end
  #Find the user if the params are updated sucessfuly redirect back to user page with sucess
  #else redirect to @user, which is defined as users homepage by rails convention "magic"

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfuly"
    redirect_to users_url
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :bio, :avatar)
    end
    #This defines updating params and such

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    #Using logged_in? method we check if a user is logged in, if they aren't redirected with flash warning
end
