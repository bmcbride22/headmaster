class StudentProfilesController < ApplicationController
  layout 'application'
  before_action :set_student_profile, only: %i[show edit update destroy]

  # GET /student_profiles
  def index
    # set the @student_profiles variable to all student_profiles
    @student_profiles = StudentProfile.all
  end

  # GET /student_profiles/:id
  def show; end

  # GET /student_profiles/new
  def new
    @cohort = Cohort.find(params[:cohort_id])
    @student_profile = StudentProfile.new
  end

  # POST /student_profiles
  def create
    @student_profile = StudentProfile.new(student_profile_params)
    @enrollment = Enrollment.new(cohort: Cohort.find(params[:cohort_id]))
    if @student_profile.save
      @enrollment.student = @student_profile
      @enrollment.save
      redirect_to @student_profile, notice: 'Student was successfully added.'
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
