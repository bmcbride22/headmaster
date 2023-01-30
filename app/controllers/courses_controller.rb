class CoursesController < ApplicationController
  layout 'application'
  before_action :set_course, only: %i[edit update destroy]
  before_action :authenticate_user!

  # GET /courses
  def index
    # set the @courses variable to all courses
    @syllabuses = Syllabus.all.where(teacher: current_user)
    @courses = Course.includes(%i[syllabus cohort]).where(syllabus: @syllabuses)
  end

  # GET /courses/:id
  def show
    @course = Course.includes({ syllabus: { units: { sections: :assessments } } }).find(params[:id])

    # TODO: Memoize the table headers in the course model and update them when a new assessment is added

    @headers = [
      { text: 'Name', value: 'student_name', fixed: true, width: 150 }
    ]
    course_grades = {}

    @course.syllabus.units.each do |unit|
      next unless unit.main_unit?

      course_grades["unit_#{unit.id}_grades".to_sym] =
        { "unit_total_grade": 0, "unit_weight": unit.weight }

      unit.sections.each do |section|
        course_grades["unit_#{unit.id}_grades".to_sym]["section_#{section.id}_grades".to_sym] =
          { "section_#{section.id}_total_grade": 0, "section_#{section.id}_weight": section.weight }

        section.assessments.each do |assessment|
          course_grades["unit_#{unit.id}_grades".to_sym]["section_#{section.id}_grades".to_sym]["assessment_#{assessment.id}_grade".to_sym] =
            'N/A'
          @headers << { text: assessment.title,
                        value: "grades.unit_#{unit.id}_grades.section_#{section.id}_grades.assessment_#{assessment.id}_grade", sortable: true }
        end
        @headers << { text: section.title,
                      value: "grades.unit_#{unit.id}_grades.section_#{section.id}_grades.section_#{section.id}_total_grade", sortable: true }
      end
      @headers << { text: unit.title, value: "grades.unit_#{unit.id}_grades.unit_total_grade", sortable: true }
    end
    @headers << { text: @course.title, value: 'grades.course_total_grade', sortable: true }

    # original way of creating the student grades hash used to populate the table with the grades,
    # but not sure how to get the calculated values, nor any counts/sums of students based on the calculated values

    @grades = Grade.includes(:student, assessment: { unit: :sections })
                   .where(course_id: @course.id)
                   .select('id, student_id, assessment_id, score')
                   .order('student_id')

    @student_row_items = []

    if @grades.empty?
      @course.students.each do |student|
        @student_row_items << { student_name: student.full_name, student_id: student.student_id,
                                grades: course_grades.deep_dup }
      end

    else
      new_student_hash = { student_name: @grades.first&.student&.full_name ||= @course.students.first.full_name, student_id: @grades.first&.student_id ||= @course.students.first.student_id,
                           grades: course_grades.deep_dup }

      @grades.each do |grade|
        if new_student_hash[:student_id] != grade.student_id
          # calculate the total grade for the student for each unit using the section grades and section weight, then the grade for course as a whole using the unit grades and the unit weights
          new_student_hash[:grades].each do |unit, unit_grades|
          end
          @student_row_items << new_student_hash

          new_student_hash = { student_name: grade.student.full_name, student_id: grade.student_id,
                               grades: course_grades.deep_dup }

        end
        new_student_hash[:grades]["unit_#{grade.assessment.unit.parent_unit_id}_grades".to_sym]["section_#{grade.assessment.unit.id}_grades".to_sym]["assessment_#{grade.assessment_id}_grade".to_sym] =
          (grade.score * 100).round(2)

        new_student_hash[:grades]["unit_#{grade.assessment.unit.parent_unit_id}_grades".to_sym]["section_#{grade.assessment.unit.id}_grades".to_sym]["section_#{grade.assessment.unit_id}_total_grade".to_sym] += ((grade.score * grade.assessment.weight) * 100).round
      end

    end
    @student_row_items << new_student_hash

    puts course_grades
    puts @student_row_item
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
