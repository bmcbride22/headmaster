class UnitsController < ApplicationController
  layout 'application'
  before_action :set_unit, only: %i[show edit update destroy]

  # GET /units
  def index
    # set the @units variable to all units
    @units = Unit.all
  end

  # GET /units/:id
  def show; end

  # GET /units/new
  def new
    @unit = Unit.new
    @syllabus = Syllabus.find_by(id: params[:syllabus_id])
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)
    @syllabus = Syllabus.find_by(id: params[syllabus_id])
    if @unit.save
      redirect_to @sylalbus, notice: "#{@unit.title} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /units/:id/edit
  def edit; end

  # PATCH /units/:id
  def update
    if @unit.update(unit_params)
      redirect_to @unit, notice: "#{@unit.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to units_path, notice: "#{@unit.title} was successfully deleted." if @unit.destroy
  end

  private

  def set_unit
    @unit = Unit.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to units_path, notice: 'Sorry, assessment unit not found'
  end

  def unit_params
    params.require(:unit).permit(%i[main_unit parent_unit_id syllabus_id weight title])
  end
end
