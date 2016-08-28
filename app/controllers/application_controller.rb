class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_user
 
  private
  def setup_user
    @user = nil
    if !session[:user].blank?
        begin
            @user = User.find(session[:user])
        rescue ActiveRecord::RecordNotFound 
            redirect_to logout_url
        end
    end
    return true
  end
end
