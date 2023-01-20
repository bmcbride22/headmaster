class DashboardsController < ApplicationController
  layout 'application'
  def main
    @cohorts = Cohort.all
  end
end
