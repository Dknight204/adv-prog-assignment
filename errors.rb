# Simple error handling
class BookingError < StandardError; end

class ResourceNotFound < BookingError
  def initialize(id)
    super("Can't find resource ##{id}")
  end
end

class AlreadyBooked < BookingError
  def initialize(name)
    super("#{name} is already taken")
  end
end

class BadTime < BookingError
  def initialize(msg = "Invalid time")
    super(msg)
  end
end

class UserError < BookingError; end
