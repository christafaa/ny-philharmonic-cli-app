class NyPhilharmonic::Concert
  attr_accessor :title, :days, :months, :times, :url, :venue, :price, :duration, :composers, :pieces

  ALL = []

  def initialize(data_hash)
    primary_info.each {|k, v| self.set_instance_variable("@#{k}", v)}
    ALL << self
  end

  def self.all
    ALL
  end

end
