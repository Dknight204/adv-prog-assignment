require_relative 'app'
require 'test/unit'

class TestBookingApp < Test::Unit::TestCase
  def setup
    @app = BookingApp.new
  end
  
  def test_add_user_works
    user = @app.add_user("John Doe", "john@example.com")
    assert_equal "John Doe", user.name
    assert_equal "john@example.com", user.email
  end
  
  def test_bad_email_fails
    assert_raises(UserError) do
      @app.add_user("John", "bad-email")
    end
  end
  
  def test_see_resources
    resources = @app.show_resources
    assert_equal 4, resources.length
    assert_equal "Projector", resources.first.name
  end
  
  def test_booking_works
    # Add a user first
    @app.add_user("John Doe", "john@example.com")
    
    start_time = Time.now + 3600
    end_time = start_time + 3600
    
    booking = @app.book_it(1, "john@example.com", start_time, end_time, "Meeting")
    assert_not_nil booking
    assert_equal 1, booking.resource_id
  end
  
  def test_past_time_fails
    @app.add_user("John Doe", "john@example.com")
    
    start_time = Time.now - 3600  # Past
    end_time = start_time + 3600
    
    assert_raises(BadTime) do
      @app.book_it(1, "john@example.com", start_time, end_time, "Meeting")
    end
  end
  
  def test_double_booking_fails
    @app.add_user("John", "john@example.com")
    @app.add_user("Jane", "jane@example.com")
    
    start_time = Time.now + 3600
    end_time = start_time + 3600
    
    # First booking should work
    booking1 = @app.book_it(1, "john@example.com", start_time, end_time, "Meeting 1")
    assert_not_nil booking1
    
    # Second should fail
    assert_raises(AlreadyBooked) do
      @app.book_it(1, "jane@example.com", start_time, end_time, "Meeting 2")
    end
  end
  
  def test_cancelling_works
    @app.add_user("John Doe", "john@example.com")
    
    start_time = Time.now + 3600
    end_time = start_time + 3600
    
    booking = @app.book_it(1, "john@example.com", start_time, end_time, "Meeting")
    cancelled = @app.cancel_booking(booking.id)
    
    assert_equal "cancelled", cancelled.status
  end
  
  def test_stats_look_right
    stats = @app.get_stats
    assert_equal 4, stats[:total_resources]
    assert_equal 4, stats[:free_resources]
    assert_equal 0, stats[:active_bookings]
  end
end

# Try it out manually
if __FILE__ == $0
  puts "=== Let's try it out ==="
  app = BookingApp.new
  
  # Add some users
  user1 = app.add_user("Dr. Tesfaye", "tesfaye@bitscollege.edu.et")
  user2 = app.add_user("Prof. Almaz", "almaz@bitscollege.edu.et")
  
  puts "Added users: #{user1.name}, #{user2.name}"
  
  # Show what we have
  puts "\nLab resources:"
  app.show_resources.each { |r| puts "- #{r}" }
  
  # Make a booking
  begin
    start_time = Time.now + 3600
    end_time = start_time + 3600
    
    booking = app.book_it(1, "tesfaye@bitscollege.edu.et", start_time, end_time, "Biology Lecture")
    puts "\n✓ Made booking ##{booking.id}"
    
    # Show what's happening
    stats = @app.get_stats
    puts "Active bookings: #{stats[:active_bookings]}"
    
  rescue => e
    puts "✗ Oops: #{e.message}"
  end
  
  puts "\n=== Running the tests ==="
  require 'test/unit'
  Test::Unit::AutoRunner.run
end
