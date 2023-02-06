class CoursesController < ApplicationController
  layout 'application'
  before_action :set_course, only: %i[edit update destroy]
  before_action :authenticate_user!

  # GET /courses
  def index
    # set the @courses variable to all courses
    @syllabuses = Syllabus.all.where(teacher: current_user)
    @courses = Course.includes(%i[syllabus cohort]).where(syllabus: @syllabuses).or(Course.where(teacher: current_user))
  end

  # GET /courses/:id
  def show
    @course = Course.includes({ syllabus: { units: :assessments } }).find(params[:id])
    teacher_courses = Course.where(syllabus: Syllabus.where(teacher: current_user))
    @courses = []
    teacher_courses.each do |course|
      @courses << { id: course.id, title: course.title }
    end

    # TODO: Memoize the table headers in the course model and update them when a new assessment is added

    @headers = [
      { text: 'Name', value: 'student_name', fixed: true, width: 150 }
    ]
    course_grades = {}

    @course.syllabus.units.includes(:sections).each do |unit|
      next unless unit.main_unit?

      course_grades["unit_#{unit.id}_grades".to_sym] =
        { "unit_total_grade": '-', "unit_weight": unit.weight }

      unit.sections.each do |section|
        course_grades["unit_#{unit.id}_grades".to_sym]["section_#{section.id}_grades".to_sym] =
          { "section_#{section.id}_total_grade": '-', "section_#{section.id}_weight": section.weight }

        section.assessments.each do |assessment|
          course_grades["unit_#{unit.id}_grades".to_sym]["section_#{section.id}_grades".to_sym]["assessment_#{assessment.id}_grade".to_sym] =
            '-'
          @headers << { text: assessment.assessment_type,
                        value: "grades.unit_#{unit.id}_grades.section_#{section.id}_grades.assessment_#{assessment.id}_grade", sortable: true, width: 50 }
        end
        @headers << { text: section.title,
                      value: "grades.unit_#{unit.id}_grades.section_#{section.id}_grades.section_#{section.id}_total_grade", sortable: true, width: 100 }
      end
      @headers << { text: unit.title, value: "grades.unit_#{unit.id}_grades.unit_total_grade", sortable: true,
                    width: 150 }
    end
    @headers << { text: @course.title, value: 'grades.course_total_grade', sortable: true, width: 150 }

    # original way of creating the student grades hash used to populate the table with the grades,
    # but not sure how to get the calculated values, nor any counts/sums of students based on the calculated values

    @grades = Grade.includes(:student, :assessment)
                   .where(course_id: @course.id)
                   .select('id, student_id, assessment_id, course_id, score')
                   .order('student_id')

    @averages = Average.where(course_id: @course.id)

    @student_row_items = []

    if @grades.empty?
      @course.students.each do |student|
        @student_row_items << { student_name: student.full_name, student_id: student.id,
                                grades: course_grades.deep_dup }
      end

    else

      new_student_hash = { student_name: @grades.first&.student&.full_name, student_id: @grades.first&.student_id,
                           grades: course_grades.deep_dup }
      @grades.each do |grade|
        if new_student_hash[:student_id] != grade.student_id
          # calculate the total grade for the student for each unit using the section grades and section weight, then the grade for course as a whole using the unit grades and the unit weights

          # Add the section averages and the unit averages to the sstudent hash from the @averages variable above

          @student_row_items << new_student_hash
          new_student_hash = { student_name: grade.student.full_name, student_id: grade.student_id,
                               grades: course_grades.deep_dup }
        end
        new_student_hash[:grades]["unit_#{grade.assessment.unit.parent_unit_id}_grades".to_sym]["section_#{grade.assessment.unit.id}_grades".to_sym]["assessment_#{grade.assessment_id}_grade".to_sym] =
          grade.score.round(2)
      end

    end

    @student_row_items << new_student_hash unless new_student_hash.nil?

    @student_row_items.each do |student|
      @course.syllabus.units.each do |unit|
        if unit.main_unit?

          student[:grades]["unit_#{unit.id}_grades".to_sym]['unit_total_grade'.to_sym] = @averages.find_by(
            student_id: student[:student_id], unit_id: unit.id, course_id: @course.id, current: true
          )&.average&.round(2)
          if student[:grades]["unit_#{unit.id}_grades".to_sym]['unit_total_grade'.to_sym].nil?
            student[:grades]["unit_#{unit.id}_grades".to_sym]['unit_total_grade'.to_sym] =
              '-'
          end
        else
          student[:grades]["unit_#{unit.parent_unit_id}_grades".to_sym]["section_#{unit.id}_grades".to_sym]["section_#{unit.id}_total_grade".to_sym] = @averages.find_by(
            student_id: student[:student_id], unit_id: unit.id, course_id: @course.id, current: true
          )&.average&.round(2)
        end
      end
      student[:grades][:course_total_grade] =
        @averages.find_by(course_avg: true, course: @course, student: student[:student_id],
                          current: true)&.average&.round(2)
    end
    course_avgs_by_date = @averages.group(:course_id, :date).order(:date).average(:average)
                                   .each_with_object({}) do |((course_id, date), average_average), m|
      m[course_id] ||= {}
      m[course_id][date] = average_average
    end
    colors = ['#4c1d95', '#8b5cf6', '#c4b5fd', '#6d28d9', '#ede9fe']
    data_sets = []
    if course_avgs_by_date.empty?
      @chart_data = {}
    else
      course_avgs_by_date.each do |course_id, avgs_by_date|
        color = colors.shift
        data_sets << {
          label: Course.find(course_id).title,
          data: avgs_by_date.values.map { |avg| avg.round(1) },
          backgroundColor: color,
          lineColor: color,
          borderColor: color,
          pointStyle: 'circle',
          pointRadius: 4
        }
      end
      @chart_data = {
        labels: course_avgs_by_date.first[1].keys.map { |date| date.strftime('%-d %b, %Y') },
        datasets: data_sets
      }.to_json
    end

    group_1 = Average.where('course_avg = true AND course_id = ? AND average >= 85 AND current = true',
                            @course.id).count
    group_2 = Average.where(
      'course_avg = true AND course_id = ? AND average < 85 AND average >= 70 AND current = true', @course.id
    ).count
    group_3 = Average.where(
      'course_avg = true AND course_id = ? AND average < 70 AND average >= 55 AND current = true', @course.id
    ).count
    group_4 = Average.where('course_avg = true AND course_id = ? AND average < 55 AND current = true',
                            @course.id).count

    group_data = [group_1, group_2, group_3, group_4]

    @achievement_groups =
      {
        labels: ['+85', '70-85', '55-70', ' 0-55'],
        datasets: [{ backgroundColor: ['#5b21b6', '#7c3aed', '#a78bfa', '#ddd6fe'],
                     label: 'Students',
                     data: group_data }]
      }.to_json
  end

  # GET /courses/new
  def new
    @course = Course.new
    @cohort = Cohort.find(params[:cohort_id]) if params[:cohort_id]
    @course.semester_courses.build
  end

  # POST /courses
  def create
    @course = Course.new(course_params)
    @course.teacher = current_user
    if @course.save
      params[:course][:semester_courses][:semester_ids].each do |semester_id|
        SemesterCourse.create(semester_id:, course_id: @course.id)
      end
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
    params.require(:course).permit([:title, :description, :cohort_id, :syllabus_id,
                                    { semester_courses: %i[id semester_id _destroy] }])
  end
end
