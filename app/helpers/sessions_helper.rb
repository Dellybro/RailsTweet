  module SessionsHelper

	
	def log_in(user)
		session[:user_id] = user.id
	end
  #log_in is used, now we have the user.id during the entire session

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  #if the box is checked we remember the user, by userID and rememberToken

  def current_user?(user)
    user == current_user
  end
  #if user == current_user which is defined below, this is a convention to stop other from
  #editing peoples profiles.


  def current_user(id=nil)
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end 
  end
  #user_id = session[:user_id] which we know that when the user logs_in, a new session is started
  #if the current_user equals the id of the session, if this isnt true than 
  #we try to log the user in by cookies.

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  #opposite of remember, we forget the user so his cookies aren't saved for the site.

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  #once called this logs_out the user, using forget, then deletes the current session and returns
  #current_user to nil

	def logged_in?
		!current_user.nil?
 	end
  #easily check to see if current_user is nil.


  #Code to implement friendly forwarding
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
    #Store url trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
