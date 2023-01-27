class SyllabusesController < ApplicationController
  layout 'application'
  before_action :set_syllabus, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /syllabuses
  def index
    # set the @syllabuses variable to all syllabuses
    @syllabuses = Syllabus.all
  end

  # GET /syllabuses/:id
  def show; end

  # GET /syllabuses/new
  def new
    @syllabus = Syllabus.new
    @syllabus.units.build
  end

  # POST /syllabuses
  def create
    @syllabus = Syllabus.new(syllabus_params)
    if @syllabus.save
      @unit = Unit.new
      @unit.syllabus_id = @syllabus.id
      @unit.title = params[:syllabus][:units_attributes][:title]
      @unit.weight = params[:syllabus][:units_attributes][:weight]
      redirect_to @syllabus, notice: 'Syllabus was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /syllabuses/:id/edit
  def edit; end

  # PATCH /syllabuses/:id
  def update
    if @syllabus.update(syllabus_params)
      redirect_to @syllabus, notice: 'Syllabus was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @syllabus.destroy
      redirect_to syllabuses_path,
                  notice: 'Syllabus was successfully deleted.'
    end
  end

  private

  def set_syllabus
    @syllabus = Syllabus.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to syllabuses_path, notice: 'Sorry, Syllabus not found'
  end

  def syllabus_params
    params.require(:syllabus).permit(%i[title subject_id teacher_id],
                                     units_attributes: %i[id title weight syllabus_id _destroy])
  end
end
