class CohortsController < ApplicationController
  layout 'application'
  before_action :set_cohort, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /cohorts
  def index
    # set the @cohorts variable to all cohorts
    @cohorts = Cohort.all
  end

  # GET /cohorts/:id
  def show; end

  # GET /cohorts/new
  def new
    @cohort = Cohort.new
  end

  # POST /cohorts
  def create
    @cohort = Cohort.new(cohort_params)

    if @cohort.save
      redirect_to @cohort, notice: "#{@cohort.name ||= 'Cohort'} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /cohorts/:id/edit
  def edit; end

  # PATCH /cohorts/:id
  def update
    if @cohort.update(cohort_params)
      redirect_to @cohort, notice: "#{@cohort.name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to cohorts_path, notice: "#{@cohort.name ||= 'Cohort'} was successfully deleted." if @cohort.destroy
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to cohorts_path, notice: 'Sorry, cohort not found'
  end

  def cohort_params
    params.require(:cohort).permit(%i[name start_date end_date])
  end
end
