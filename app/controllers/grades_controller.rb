class GradesController < ApplicationController
  layout 'application'
  before_action :set_grade, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /grades
  def index
    # set the @grades variable to all grades
    @grades = Grade.all.where(course: current_user.courses)
  end

  # GET /grades/:id
  def show; end

  # GET /grades/new
  def new
    @grade = Grade.new
  end

  def set_course
    @courses = Course.where(syllabus: current_user.syllabuses)
  end

  def new_assessment_grades
    @course = Course.includes({ cohort: :students }).find_by(id: params[:course_id])
    @assessment = Assessment.find_by(id: params[:assessment_id]) if params[:assessment_id]
    @grades = []
    @course.cohort.students.each do |_i|
      @grades << Grade.new
    end
  end

  def create_assessment_grades
    assessment = Assessment.includes(:syllabus).find(params[:assessment_id])
    params[:grades].each do |grade_attrs|
      grade = Grade.new(student_id: grade_attrs[:student_id], score: grade_attrs[:score],
                        course_id: grade_attrs[:course_id])
      grade.assessment = assessment
      grade.save
    end

    redirect_to course_path(params[:grades][0][:course_id])
  end

  # POST /grades
  def create
    @grade = Grade.new(grade_params)

    if @grade.save
      redirect_to @grade, notice: "#{@grade.name ||= 'Grade'} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /grades/:id/edit
  def edit; end

  # PATCH /grades/:id
  def update
    if @grade.update(grade_params)
      redirect_to @grade, notice: "#{@grade.name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to grades_path, notice: "#{@grade.name ||= 'Grade'} was successfully deleted." if @grade.destroy
  end

  private

  def set_grade
    @grade = Grade.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to grades_path, notice: 'Sorry, grade not found'
  end

  def grade_params
    params.require(:grade).permit(%i[marks score assessment_id course_id student_id])
  end
end
