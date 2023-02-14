class PagesController < ApplicationController
  layout 'pages'
  def home
    redirect_to dashboard_path if user_signed_in?
  end

  def landing_page
    redirect_to dashboard_path if user_signed_in?
		@demo_user = User.first
  end
end
