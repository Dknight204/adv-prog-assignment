require 'json'

class SimpleBooking
  def initialize
    @resources = [
      { "id" => 1, "name" => "Projector", "booked" => false },
      { "id" => 2, "name" => "Microscope", "booked" => false },
      { "id" => 3, "name" => "Laptop", "booked" => false },
      { "id" => 4, "name" => "Router Kit", "booked" => false }
    ]
    @bookings = []
  end

  def list_resources
    @resources.each do |resource|
      status = resource["booked"] ? "Booked" : "Available"
      puts "#{resource['id']}. #{resource['name']} - #{status}"
    end
  end

  def book_resource(resource_id, user_name)
    resource = @resources.find { |r| r["id"] == resource_id }
    
    unless resource
      puts "Resource not found"
      return false
    end

    if resource["booked"]
      puts "Resource already booked"
      return false
    end

    resource["booked"] = true
    @bookings << {
      "resource_id" => resource_id,
      "user_name" => user_name,
      "time" => Time.now
    }
    
    puts "#{resource['name']} booked by #{user_name}"
    true
  end

  def cancel_booking(resource_id)
    resource = @resources.find { |r| r["id"] == resource_id }
    booking = @bookings.find { |b| b["resource_id"] == resource_id }
    
    if resource && booking
      resource["booked"] = false
      @bookings.delete(booking)
      puts "#{resource['name']} booking cancelled"
      true
    else
      puts "No booking found"
      false
    end
  end

  def list_bookings
    if @bookings.empty?
      puts "No active bookings"
    else
      puts "Active bookings:"
      @bookings.each do |booking|
        resource = @resources.find { |r| r["id"] == booking["resource_id"] }
        puts "- #{resource['name']} booked by #{booking['user_name']}"
      end
    end
  end
end

# To use this system:
# system = SimpleBooking.new
# system.list_resources
# system.book_resource(1, "Your Name")
# system.cancel_booking(1)
# system.list_bookings
