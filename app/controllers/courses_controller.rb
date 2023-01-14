class CoursesController < ApplicationController
  layout 'application'
  before_action :set_course, only: %i[show edit update destroy]

  # GET /courses
  def index
    # set the @courses variable to all courses
    @courses = Course.all
  end

  # GET /courses/:id
  def show; end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: "#{@course.title ||= 'Course'} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /courses/:id/edit
  def edit; end

  # PATCH /courses/:id
  def update
    if @course.update(course_params)
      redirect_to @course, notice: "#{@course.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to courses_path, notice: "#{@course.title ||= 'Course'} was successfully deleted." if @course.destroy
  end

  private

  def set_course
    @course = Course.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to courses_path, notice: 'Sorry, course not found'
  end

  def course_params
    params.require(:course).permit(%i[title description start_date end_date cohort_id syllabus_id])
  end
end
