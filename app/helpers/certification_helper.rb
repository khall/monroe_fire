module CertificationHelper
  def existing_cert(cert_id)
    if current_user && (current_user.webmaster? || current_user.chief?)
      link_to("&nbsp;".html_safe, "certifications/#{cert_id}/update_progress", method: :put, remote: true)
    else
      ""
    end
  end

  def new_cert(user_id, course_id)
    if current_user && (current_user.webmaster? || current_user.chief?)
      link_to("&nbsp;".html_safe, "certifications/gen?user_id=#{user_id}&course_id=#{course_id}", method: :put, remote: true)
    else
      ""
    end
  end
end