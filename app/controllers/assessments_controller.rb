# app/controllers/assessments_controller.rb
class AssessmentsController < ApplicationController
  before_action :find_or_create_assessment, except: [ :show, :result ]
  before_action :set_assessment, only: [ :show, :result ]

  def start
    redirect_to step_assessments_path(esercizio: 1)
  end

  def step
    @current_step = params[:esercizio].to_i

    # Validate step number
    if @current_step < 1 || @current_step > 10
      redirect_to step_assessments_path(esercizio: 1) and return
    end

    @assessment.current_step = @current_step

    # Load exercise data if it's an exercise step (1-9)
    if @current_step <= 9
      @exercise = Assessment::EXERCISES[@current_step]
    end

    render :step
  end

  def update_step
    @current_step = params[:esercizio].to_i
    @assessment.current_step = @current_step

    if @assessment.update(assessment_params_for_step(@current_step))
      # Determine next step
      if @current_step == 10 && @assessment.is_complete?
        @assessment.update(completed: true, completed_at: Time.current)
        redirect_to review_assessments_path
      else
        next_step = @current_step + 1
        if next_step <= 10
          redirect_to step_assessments_path(esercizio: next_step)
        else
          redirect_to review_assessments_path
        end
      end
    else
      # Re-render current step with errors
      if @current_step <= 9
        @exercise = Assessment::EXERCISES[@current_step]
      end
      render :step
    end
  end

  def review
    if @assessment.is_complete?
      render :review
    else
      # Find first incomplete step
      incomplete_step = find_first_incomplete_step
      redirect_to step_assessments_path(esercizio: incomplete_step)
    end
  end

  def create
    if @assessment.update(completed: true, completed_at: Time.current)
      redirect_to result_assessment_path(@assessment)
    else
      redirect_to review_assessments_path
    end
  end

  def show
    redirect_to result_assessment_path(@assessment)
  end

  def result
    @mobility_data = @assessment.mobility_level
  end

  private

  def find_or_create_assessment
    token = session[:assessment_token]

    if token && (@assessment = Assessment.find_by(session_token: token, completed: false))
      # Continue existing assessment
    else
      # Create new assessment
      @assessment = Assessment.create!(session_token: SecureRandom.hex(16))
      session[:assessment_token] = @assessment.session_token
    end
  end

  def set_assessment
    @assessment = Assessment.find(params[:id])
  end

  def find_first_incomplete_step
    return 1 if @assessment.flexion_extension.nil?
    return 2 if @assessment.arms_overhead.nil?
    return 3 if @assessment.spine_rotation_right.nil?
    return 4 if @assessment.spine_rotation_left.nil?
    return 5 if @assessment.deep_squat.nil?
    return 6 if @assessment.hands_behind_back_right.nil?
    return 7 if @assessment.hands_behind_back_left.nil?
    return 8 if @assessment.straight_leg_raise_right.nil?
    return 9 if @assessment.straight_leg_raise_left.nil?
    return 10 if @assessment.name.blank? || @assessment.age.blank? || @assessment.email.blank?
    10 # All complete
  end

  def assessment_params_for_step(step)
    case step
    when 1
      params.require(:assessment).permit(:flexion_extension)
    when 2
      params.require(:assessment).permit(:arms_overhead)
    when 3
      params.require(:assessment).permit(:spine_rotation_right)
    when 4
      params.require(:assessment).permit(:spine_rotation_left)
    when 5
      params.require(:assessment).permit(:deep_squat)
    when 6
      params.require(:assessment).permit(:hands_behind_back_right)
    when 7
      params.require(:assessment).permit(:hands_behind_back_left)
    when 8
      params.require(:assessment).permit(:straight_leg_raise_right)
    when 9
      params.require(:assessment).permit(:straight_leg_raise_left)
    when 10
      params.require(:assessment).permit(:name, :age, :email, :phone_country_code, :phone_number, :privacy_consent, :marketing_consent, :notes)
    else
      {}
    end
  end
end
