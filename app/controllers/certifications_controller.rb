class CertificationsController < ApplicationController
  #load_and_authorize_resource

  def index
    @users = User.firefighters
    @courses = Course.all
  end

  def update_progress
    @certification = Certification.find(params[:id])
    if @certification.progress == "in-progress"
      @certification.update_attribute(:progress, "complete")
      render :js => "$('#td_#{@certification.id}').removeClass('in-progress').addClass('complete')"
    elsif @certification.progress == "complete"
      @certification.update_attribute(:progress, "incomplete")
      render :js => "$('#td_#{@certification.id}').removeClass('complete').addClass('incomplete')"
    else
      @certification.update_attribute(:progress, "in-progress")
      render :js => "$('#td_#{@certification.id}').removeClass('incomplete').addClass('in-progress')"
    end
  end

  def gen
    c = Certification.create(user_id: params[:user_id], course_id: params[:course_id], progress: "in-progress")
    dom_id = "#td_#{params[:user_id]}_#{params[:course_id]}"
    render :js => "$('#{dom_id}').removeClass('incomplete').addClass('in-progress');
                   $('#{dom_id}').children().attr('href', 'certifications/#{c.id}/update_progress');
                   $('#{dom_id}').attr('id', 'td_#{c.id}');"
  end
end