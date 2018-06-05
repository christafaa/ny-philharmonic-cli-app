class NyPhilharmonic::CLI
  attr_accessor :pages, :curent_index, :scraper

  def initialize
    @pages = []
    @current_index = 0
    @scraper = NyPhilharmonic::Scraper.new
  end

  def call
    @scraper.get_concert_urls
    puts "Welcome to The New York Philharmonic CLI App"
    puts "Loading concerts (this may take a moment)..."
    @pages << @scraper.create_new_page
    display_page
  end

  def display_page
    system("clear")
    puts "The New York Philharmonic CLI App"
    puts "\nEnter a concert's number to see more information about that concert"
    puts "Enter '>' to scroll to the next page"
    puts "Enter '<' to scroll to the previous page (Do not use arrow keys)"
    puts "Enter 'exit' to quit the program"
    puts "\nUpcoming concerts: "
    @pages[@current_index].concerts.each do |concert|
      puts "\n#{concert.number}. #{concert.title}"
      puts "\tDate(s): #{concert.short_date}"
    end

    puts "\n\t< Page #{@current_index + 1} >"
    print "\nEnter a command: "
    input = gets.chomp.downcase

    concert_numbers = @pages[@current_index].concerts.map{|concert| concert.number}

    if input == ">"
      next_page
    elsif input == "<"
      previous_page
    elsif concert_numbers.include?(input.to_i)
      display_concert(input.to_i)
    elsif input == "exit"
      exit
    else
      display_page
    end
  end

  def display_concert(number)
    system("clear")
    puts "The New York Philharmonic CLI App"

    concert = NyPhilharmonic::Concert.find_by_number(number)
    puts "\n#{concert.title}"

    puts "\nLocation: #{concert.venue}" if concert.venue
    puts "Price: #{concert.price}" if concert.price
    puts "Duration: #{concert.duration}" if concert.duration

    puts "\nDates:"
    concert.full_date_with_time.each {|time| puts "\t#{time}"}

    puts "\nProgram:"
    concert.program.each {|program| puts "\t#{program}"}

    puts "\nWhat would you like to do?"
    puts "1. Open this concert in your browser"
    puts "2. Go back to list"
    puts "3. Exit program"
    print "Enter a number: "

    input = gets.chomp

    if input == "1"
      system("open", "#{concert.url}")
      display_concert(number)
    elsif input == "2"
      display_page
    elsif input == "3"
      exit
    else
      display_concert(number)
    end
  end

  def next_page
    @current_index += 1
    if @pages[@current_index] == nil
      puts "Loading concerts (this may take a moment)..."
      @pages << @scraper.create_new_page

      if @pages.last.concerts.length == 0
        @pages.pop
        @current_index -= 1
      end
    end
    display_page
  end

  def previous_page
    @current_index -= 1 unless @current_index == 0
    display_page
  end
end
