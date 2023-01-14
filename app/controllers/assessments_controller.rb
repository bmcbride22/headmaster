class AssessmentsController < ApplicationController
  layout 'application'
  before_action :set_assessment, only: %i[show edit update destroy]

  # GET /assessments
  def index
    # set the @assessments variable to all assessments
    @assessments = Assessment.all
  end

  # GET /assessments/:id
  def show; end

  # GET /assessments/new
  def new
    @assessment = Assessment.new

    @subjects = Subject.all
  end

  # POST /assessments
  def create
    @assessment = Assessment.new(assessment_params)

    @assessment.unit = Unit.find(params[:assessment][:unit_id])

    if @assessment.save
      redirect_to @assessment, notice: 'Assessment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /assessments/:id/edit
  def edit; end

  # PATCH /assessments/:id
  def update
    if @assessment.update(assessment_params)
      redirect_to @assessment, notice: 'Assessment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to assessments_path, notice: 'Assessment was successfully deleted.' if @assessment.destroy
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to assessments_path, notice: 'Sorry, assessment not found'
  end

  def assessment_params
    params.require(:assessment).permit(%i[date unit_weight instrument_id unit_id])
  end
end