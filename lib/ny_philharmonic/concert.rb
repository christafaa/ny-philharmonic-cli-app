class NyPhilharmonic::Concert
  attr_accessor :title, :days, :months, :times, :url, :venue, :price, :duration, :composers, :pieces, :number

  ALL = []

  def initialize(data_hash)
    data_hash.each {|k, v| self.instance_variable_set("@#{k}", v)}
    ALL << self
  end

  def self.all
    ALL
  end

  def dates
    result = []
    @months.each_with_index do |month, i|
      month_data = month.split(", ")
      result << "#{month_data[0]} #{@days[i]}, #{month_data[1]}"
    end
    result.join("; ")
  end

end
