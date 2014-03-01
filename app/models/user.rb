class User < ActiveRecord::Base
  ROLES = %w|firefighter chief webmaster|
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :answers
  has_many :certifications
  has_many :courses, through: :certifications

  scope :firefighters, -> { where("role = 'firefighter' OR role = 'chief' OR role = 'webmaster'") }

  def firefighter?
    role == 'chief' || role == 'webmaster' || role == 'firefighter'
  end

  def method_missing(id, *args)
    # such as .chief? or .webmaster?
    return self.role == Regexp.last_match(1) if id.id2name =~ /^(.+)\?$/

    # such as .tool_quiz_percentage
    return self.answers.question_type(Regexp.last_match(1)).percent_correct[0].percent.to_i if id.id2name =~ /^(.+)_percentage$/

    # such as .tool_quiz_correct
    return self.answers.question_type(Regexp.last_match(1)).correct[0].count.to_i if id.id2name =~ /^(.+)_correct$/

    #raise NoMethodError, "method: #{id.id2name}"
    logger.warn "No user method: #{id.id2name}"
  end

  def certified_list
    all_certs = Certification.all
    certifications.each do |mine|
      all_certs.each do |cert|
        all_certs = mine if cert.id == mine.id
      end
    end
    byebug
    list.sort(&:id)
  end
end
