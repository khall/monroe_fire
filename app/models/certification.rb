class Certification < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  def complete?
    progress == "complete"
  end

  def in_progress?
    progress == "in-progress"
  end
end
