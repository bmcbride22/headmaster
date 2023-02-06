class StudentProfilesController < ApplicationController
  layout 'application'
  before_action :set_student_profile, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /student_profiles
  def index
    # set the @student_profiles variable to all student_profiles
    @student_profiles = StudentProfile.all
  end

  # GET /student_profiles/:id
  def show
    @averages = Average.includes(:unit, { course: :cohort }).where(student_id: @student_profile.id)
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
          data: avgs_by_date.values.map { |avg| avg.round(2) },
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
    group_1 = Grade.where('student_id = ? AND score >= 85 ', @student_profile.id).count
    group_2 = Grade.where('student_id = ? AND score < 85 AND score >= 70 ',
                          @student_profile.id).count
    group_3 = Grade.where('student_id = ? AND score < 70 AND score >= 55 ',
                          @student_profile.id).count
    group_4 = Grade.where('student_id = ? AND score < 55 ', @student_profile.id).count

    group_data = [group_1, group_2, group_3, group_4]

    @achievement_groups =
      {
        labels: ['+85', '70-85', '55-70', ' 0-55'],
        datasets: [{ backgroundColor: ['#5b21b6', '#7c3aed', '#a78bfa', '#ddd6fe'],
                     label: 'Assessments in this range',
                     data: group_data }]
      }.to_json
  end

  # GET /student_profiles/new
  def new
    @cohort = Cohort.find(params[:cohort_id])
    @student_profile = StudentProfile.new
  end

  # POST /student_profiles
  def create
    @student_profile = StudentProfile.new(student_profile_params)
    @cohort = Cohort.find(params[:cohort_id])
    @enrollment = Enrollment.new(cohort: @cohort)
    if @student_profile.save
      @enrollment.student = @student_profile
      @enrollment.save
      redirect_to @cohort, notice: 'Student was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /student_profiles/:id/edit
  def edit; end

  # PATCH /student_profiles/:id
  def update
    if @student_profile.update(student_profile_params)
      @enrollment = Enrollment.find_by(student: @student_profile)
      @enrollment.cohort = Cohort.find(params[:student_profile][:enrollments][:cohort_id])
      @enrollment.save
      redirect_to @student_profile, notice: 'Student profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @student_profile.destroy
      redirect_to student_profiles_path,
                  notice: 'Student profile was successfully deleted.'
    end
  end

  private

  def set_student_profile
    @student_profile = StudentProfile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to student_profiles_path, notice: 'Sorry, Student profile not found'
  end

  def student_profile_params
    params.require(:student_profile).permit(%i[first_name last_name cohort_id])
  end
end
