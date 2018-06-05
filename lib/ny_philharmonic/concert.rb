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

  def program
    @composers.map.with_index {|composer, i| "#{composer}: #{@pieces[i]}"}
  end

  def short_date
    @months.map.with_index do |month, i|
      month_data = month.split(", ")
      "#{month_data[0]} #{@days[i]}, #{month_data[1]}"
    end.join("; ")
  end

  def full_date_with_time
    @months.map.with_index do |month, i|
      month_data = month.split(", ")
      time_data = times[i].split(", ")
      "#{time_data[1]}, #{time_data[0]}, #{month_data[0]} #{@days[i]}, #{month_data[1]}"
    end
  end

  def self.find_by_number(number)
    ALL.find {|concert| concert.number == number}
  end
end
