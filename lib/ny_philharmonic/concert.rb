class NyPhilharmonic::Concert
  attr_accessor :title, :dates, :times, :url, :venue, :price, :duration, :description

  ALL = []

  def initialize(data_hash)
    primary_info.each {|k, v| self.set_instance_variable("@#{k}", v)}
    ALL << self
  end

  def self.all
    ALL
  end

end
