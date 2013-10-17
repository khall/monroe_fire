class User < ActiveRecord::Base
  ROLES = %w|firefighter chief webmaster|
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :answers

  def method_missing(id, *args)
    # such as .firefighter? or .webmaster?
    return self.role == Regexp.last_match(1) if id.id2name =~ /^(.+)\?$/

    # such as .tool_quiz_percentage
    return self.answers.question_type(Regexp.last_match(1)).percent_correct[0].percent.to_i if id.id2name =~ /^(.+)_percentage$/

    # such as .tool_quiz_correct
    return self.answers.question_type(Regexp.last_match(1)).correct[0].count.to_i if id.id2name =~ /^(.+)_correct$/

    raise NoMethodError, "method: #{id.id2name}"
  end
end
