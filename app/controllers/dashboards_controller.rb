class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout 'application'
  def main
    @cohorts = current_user.classes
  end
end
