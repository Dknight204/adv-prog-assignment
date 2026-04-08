# A person who can book resources
class User
  attr_accessor :name, :email
  
  def initialize(name, email)
    @name = name
    @email = email
  end
  
  def has_good_email?
    @email.include?("@") && @email.include?(".")
  end
  
  def to_s
    "#{@name} (#{@email})"
  end
end

# Keeps track of all users
class UserManager
  def initialize
    @users = []
  end
  
  def add_user(name, email)
    user = User.new(name, email)
    raise UserError, "Bad email address" unless user.has_good_email?
    @users << user
    user
  end
  
  def find_by_email(email)
    @users.find { |u| u.email == email }
  end
  
  def check_user_exists(email)
    user = find_by_email(email)
    raise UserError, "Don't know this user" unless user
    user
  end
end
