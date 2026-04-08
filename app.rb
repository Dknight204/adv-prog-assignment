require_relative 'errors'
require_relative 'resource'
require_relative 'user'

# A booking for a resource
class Booking
  attr_accessor :id, :resource_id, :user_email, :start_time, :end_time, :purpose, :status
  
  def initialize(id, resource_id, user_email, start_time, end_time, purpose)
    @id = id
    @resource_id = resource_id
    @user_email = user_email
    @start_time = start_time
    @end_time = end_time
    @purpose = purpose
    @status = "active"
  end
  
  def still_active?
    @status == "active"
  end
  
  def cancel_it
    @status = "cancelled"
  end
  
  def time_clash?(start_time, end_time)
    return false unless still_active?
    return (@start_time < end_time && @end_time > start_time)
  end
end

# The main booking system
class BookingApp
  def initialize
    @resources = ResourceManager.new
    @users = UserManager.new
    @bookings = []
    @next_id = 1
  end
  
  # Get all resources
  def show_resources
    @resources.all_resources
  end
  
  # Add a new user
  def add_user(name, email)
    @users.add_user(name, email)
  end
  
  # Make a booking
  def book_it(resource_id, user_email, start_time, end_time, purpose)
    # Check if we know this user
    user = @users.check_user_exists(user_email)
    
    # Find the resource
    resource = @resources.find_by_id(resource_id)
    
    # Check times make sense
    raise BadTime, "End time must be after start time" if start_time >= end_time
    raise BadTime, "Can't book in the past" if start_time <= Time.now
    
    # See if anyone else has it booked
    clashes = @bookings.select do |booking|
      booking.resource_id == resource_id && booking.time_clash?(start_time, end_time)
    end
    
    raise AlreadyBooked, resource.name if clashes.any?
    
    # Make the booking
    booking = Booking.new(@next_id, resource_id, user_email, start_time, end_time, purpose)
    @bookings << booking
    @next_id += 1
    
    booking
  end
  
  # Cancel a booking
  def cancel_booking(booking_id)
    booking = @bookings.find { |b| b.id == booking_id }
    raise ResourceNotFound, booking_id unless booking
    raise BookingError, "Already cancelled" unless booking.still_active?
    
    booking.cancel_it
    booking
  end
  
  # See all active bookings
  def current_bookings
    @bookings.select(&:still_active?)
  end
  
  # See what a user has booked
  def user_bookings(user_email)
    @bookings.select { |b| b.user_email == user_email && b.still_active? }
  end
  
  # Get some stats
  def get_stats
    {
      total_resources: @resources.all_resources.length,
      free_resources: @resources.whats_available.length,
      active_bookings: current_bookings.length,
      all_bookings: @bookings.length
    }
  end
end
