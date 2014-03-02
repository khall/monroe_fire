class CertificationsController < ApplicationController
  #load_and_authorize_resource

  def index
    @users = User.firefighters.sort_by{|u| u.name.split(' ').last}
    @courses = Course.all
  end

  def update_progress
    @certification = Certification.find(params[:id])
    if @certification.progress == "incomplete"
      @certification.update_attribute(:progress, "complete")
      render :js => "$('#td_#{@certification.id}').removeClass('incomplete').addClass('complete')"
    elsif @certification.progress == "in-progress"
      @certification.update_attribute(:progress, "incomplete")
      render :js => "$('#td_#{@certification.id}').removeClass('in-progress').addClass('incomplete')"
    else
      @certification.update_attribute(:progress, "in-progress")
      render :js => "$('#td_#{@certification.id}').removeClass('complete').addClass('in-progress')"
    end
  end

  def gen
    c = Certification.create(user_id: params[:user_id], course_id: params[:course_id], progress: "complete")
    dom_id = "#td_#{params[:user_id]}_#{params[:course_id]}"
    render :js => "$('#{dom_id}').removeClass('incomplete').addClass('complete');
                   $('#{dom_id}').children().attr('href', 'certifications/#{c.id}/update_progress');
                   $('#{dom_id}').attr('id', 'td_#{c.id}');"
  end
end