class NyPhilharmonic::Concert
  attr_accessor :title, :date, :time, :url, :venue, :price, :duration, :description

  ALL = []

  def initialize(primary_info)
    primary_info.each {|k, v| self.set_instance_variable("@#{k}", v)}
    ALL << self
  end

  def self.all
    ALL
  end

end
