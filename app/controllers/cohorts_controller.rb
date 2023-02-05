class CohortsController < ApplicationController
  layout 'application'
  before_action :set_cohort, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /cohorts
  def index
    # set the @cohorts variable to all cohorts
    @cohorts = Cohort.where(id: current_user.classes).or(Cohort.where(teacher: current_user))
    @achievement_groups = []

    @cohorts.each do |cohort|
      group_1 = Average.where(average: (0.85..1.0), course_avg: true, current: true,
                              student_id: cohort.students.ids).count
      group_2 = Average.where(average: (0.7..0.85), course_avg: true, current: true,
                              student_id: cohort.students.ids).count

      group_3 =  Average.where(average: (0.55..0.7), course_avg: true, current: true,
                               student_id: cohort.students.ids).count
      group_4 =  Average.where(average: (0.0..0.55), course_avg: true, current: true,
                               student_id: cohort.students.ids).count
      group_data = [group_1, group_2, group_3, group_4]

      chart_data = {
        labels: ['+85', '70-85', '55-70', ' 0-55'],
        datasets: [{ backgroundColor: ['#5b21b6', '#7c3aed', '#a78bfa', '#ddd6fe'],
                     label: 'Students in this grade range',
                     data: group_data }]
      }

      @achievement_groups << chart_data
    end
  end

  # GET /cohorts/:id
  def show
    teacher_cohorts = Cohort.includes({ courses: :syllabus }).where(id: current_user.classes).or(Cohort.where(teacher: current_user))
    @cohorts = []
    teacher_cohorts.each do |cohort|
      @cohorts << { id: cohort.id, title: cohort.name }
    end
  end

  # GET /cohorts/new
  def new
    @cohort = Cohort.new
    @cohort.semester_cohorts.build
  end

  # POST /cohorts
  def create
    @cohort = Cohort.new(cohort_params)
    @cohort.teacher = current_user
    if @cohort.save
      params[:semester_cohorts][:semester_ids].each do |semester_id|
        SemesterCohort.create(semester_id:, cohort_id: @cohort.id)
      end
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
    params.require(:cohort).permit([:name, { semester_courses_attributes: %i[id semester_id _destroy] }])
  end
end
