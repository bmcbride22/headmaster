class CoursesController < ApplicationController
  layout 'application'
  before_action :set_course, only: %i[edit update destroy]

  # GET /courses
  def index
    # set the @courses variable to all courses
    @courses = Course.includes(%i[syllabus cohort]).all
    @syllabuses = Syllabus.all
  end

  # GET /courses/:id
  def show
    @course = Course.includes({ cohort: :students },
                              { syllabus: { units: { sections: { assessments: { grades: :student } } } } }).find(params[:id])

    @headers = [{ text: 'Student', value: 'student_id' }, { text: 'Name', value: 'student_name' }]
    course_grades = {}

    @course.syllabus.units.each do |unit|
      next unless unit.main_unit?

      course_grades["unit_#{unit.id}_grades"] = {}

      unit.sections.each do |section|
        course_grades["unit_#{unit.id}_grades"]["section_#{section.id}_grades"] = {}

        section.assessments.each do |assessment|
          course_grades["unit_#{unit.id}_grades"]["section_#{section.id}_grades"]["assessment_#{assessment.id}_grades"] =
            {}
          @headers << { text: assessment.title, value: "grades.assessment_#{assessment.id}_score" }
        end
        @headers << { text: section.title, value: "section_#{section.id}_total_score" }
      end
      @headers << { text: unit.title, value: "unit_#{unit.id}_total_score" }
    end

    @grades = Grade.includes(:student, { assessment: { unit: :sections } })
                   .where(course_id: @course.id)
                   .select('id, student_id, assessment_id, score, grades.assessments.weight, assessments.unit_id, units.weight, units.parent_unit_id')
                   .order('student_id')

    @student_row_items = []
    new_student_hash = { student_name: @grades.first.student.full_name, student_id: @grades.first.student_id,
                         grades: {} }
    @grades.each do |grade|
      if new_student_hash[:student_id] != grade.student_id

        @student_row_items << new_student_hash
        new_student_hash = { student_name: grade.student.full_name, student_id: grade.student_id, grades: {} }
      end
      new_student_hash[:grades]["assessment_#{grade.assessment_id}_score"] = grade.score
    end
  end

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
