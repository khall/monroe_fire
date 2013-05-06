class User < ActiveRecord::Base
  ROLES = %w|firefighter chief webmaster|
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def method_missing(id, *args)
    return role == Regexp.last_match(1) if id.id2name =~ /^(.+)\?$/
    raise NoMethodError
  end
end
