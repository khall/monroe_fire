class Answer < ActiveRecord::Base
  attr_accessible :correct, :question_id, :question_type, :user_id

  belongs_to :user
  #belongs_to :question
                                                                               #
  scope :question_type, -> {|t| where("question_type = ?", t) }
  scope :percent_correct, -> { select("100 * AVG(correct::int) as percent") }
  scope :correct, -> { where("correct = true").select("count(correct) as count") }
end
