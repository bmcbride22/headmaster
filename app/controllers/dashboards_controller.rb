class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout 'application'
  def main
    @cohorts = Cohort.all
  end
end
