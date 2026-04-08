# A lab resource we can book
class Resource
  attr_accessor :id, :name, :type, :location, :available
  
  def initialize(id, name, type, location)
    @id = id
    @name = name
    @type = type
    @location = location
    @available = true
  end
  
  def book_it
    @available = false
  end
  
  def free_it_up
    @available = true
  end
  
  def to_s
    "#{@name} (#{@type}) - #{@location}"
  end
end

# Manages all our lab resources
class ResourceManager
  def initialize
    @resources = [
      Resource.new(1, "Projector", "equipment", "Lecture Hall A"),
      Resource.new(2, "Microscope", "equipment", "Biology Lab 201"),
      Resource.new(3, "Laptop", "computer", "Computer Lab 101"),
      Resource.new(4, "Router Kit", "equipment", "Network Lab 302")
    ]
  end
  
  def all_resources
    @resources
  end
  
  def find_by_id(id)
    resource = @resources.find { |r| r.id == id }
    raise ResourceNotFound, id unless resource
    resource
  end
  
  def whats_available
    @resources.select(&:available)
  end
end
