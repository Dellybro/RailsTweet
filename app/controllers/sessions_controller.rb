class SessionsController < ApplicationController

  def ads
    redirect_to("http://www.milliondollarhomepage.com/")
  end
  def github
    redirect_to("http://www.github.com/dellybro")
  end

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = "You have successfully logged in! Thanks for using TwitterClone.com!"
        redirect_back_or user
      else
        message = "Account not activated. \n Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  #this creates a new session, we find the user by email and the params.downcase
  #we test the authentication for password, if everything comes true,
  #log_in method is a used which is inside the Module sessionsHelper, it just logs in the user.
  #2 important methods are included here, remember(user) and forget(user)
  #forget(user) is in the class, which is called when a user logOff, or if the user
  #checks the button to keep logged in on computer.
  #if everything fails, redirect back to page with flash.

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  #We use cookies in order to define the users home computer,
  #if the user logs out we forget the user, but if the user just clicks exit on the web browser
  #the next time they come to the site they will be "remember" methoded.

  def destroy
    log_out if logged_in?
    flash[:success] = "You have successfully logged out! Thanks for visiting us at TwitterClone.com!"
    redirect_to root_url
  end
  #pretty simple, theres a log_out method, that logs the user out and uses forget method
  #redirects to root_url
end
