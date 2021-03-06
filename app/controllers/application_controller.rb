class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  # Setting Deafault jump
  def after_sign_in_path_for(resource)
    admin_root_path = "/kinmu/show"
  end
  def after_sign_out_path_for(resource_or_scope)
    admin_root_path = "/users/sign_in"
  end
end
