class NyPhilharmonic::Page
  attr_accessor :concerts
  attr_reader :number

  ALL = []

  def initialize(concerts)
    @concerts = concerts
    ALL << self
    @number = ALL.length
  end

  def self.all
    ALL
  end
end
