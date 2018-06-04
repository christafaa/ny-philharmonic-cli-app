class NyPhilharmonic::CLI
  attr_accessor :pages, :curent_index, :scraper

  def initialize
    @pages = []
    @current_index = 0
    @scraper = NyPhilharmonic::Scraper.new
  end

  def call
    puts "\nWelcome to The New York Philharmonic CLI App"
    puts "Loading concerts (this may take a moment)..."
    @scraper.get_concert_urls
    @pages << @scraper.create_new_page
    display_page
  end

  def display_page
    system("clear")
    puts "\nUpcoming concerts: "
    @pages[@current_index].concerts.each do |concert|
      puts "\n#{concert.number}. #{concert.title}"
      puts "\tDate(s): #{concert.dates}"
    end

    puts "\n\t< Page #{@current_index + 1} >"
    puts "\nEnter a concert's number to see more information about that concert"
    puts "Enter '<' to scroll back and '>' to scroll forward (do not use arrow keys)"
    #puts "Enter 'menu' to see a full list of commands"
    print "Enter a command: "
    input = gets.chomp.downcase

    concert_numbers = @pages[@current_index].concerts.map{|concert| concert.number}

    if input == ">"
      next_page
    elsif input == "<"
      previous_page
    elsif concert_numbers.include?(input.to_i)
      display_concert(input)
    else
      display_page
    end
  end

  def display_concert(number)
    system("clear")
    concert = NyPhilharmonic::Concert.find_by_number(number.to_i)
    puts concert.title

    puts "\nLocation: #{concert.venue}" unless concert.venue == nil
    puts "Price: #{concert.price}" unless concert.price == nil
    puts "Duration: #{concert.duration}" unless concert.duration == nil

    puts "\nDates:"
    concert.full_date_with_time.each {|time| puts "\t#{time}"}

    puts "\nPROGRAM:"
    concert.program.each {|program| puts "\t#{program}"}

    puts "\nWhat would you like to do?"
    puts "1. Open this concert in your browser"
    puts "2. Go back to list"
    print "Enter a number: "

    input = gets.chomp

    if input == "1"
      system("open", "#{concert.url}")
      display_concert(number)
    elsif input == "2"
      system("clear")
      display_page
    else
      display_concert(number)
    end
  end

  # def menu
  #
  #   puts "\nTo learn more about a concert, enter its number"
  #   puts "To scroll forward and view more concerts, enter '>'"
  #   puts "To scroll back and view previous concerts, enter '<'"
  #
  #   puts "1. Search all performances"
  #   puts "2. Search performances by month"
  #   puts "3. Exit program"
  #   print "Enter a number: "
  # end

  def next_page
    @current_index += 1
    if @pages[@current_index] == nil
      puts "Loading concerts (this may take a moment)..."
      @pages << @scraper.create_new_page

      if @pages.last.concerts.length == 0
        system("clear")
        puts "There are no additional concerts"
        @pages.pop
        @current_index -= 1
        display_page
      end

      system("clear")
      display_page
    else
      system("clear")
      display_page
    end
  end

  def previous_page
    if @current_index == 0
      system("clear")
      puts "There are no previous concerts."
    else
      @current_index -= 1
      system("clear")
    end
    display_page
  end

  def pages
    NyPhilharmonic::Page.all
  end

  # def search_performances
  #   system("clear")
  #   puts "--- Searching performances ---"
  #   puts "1. List all performances"
  #   puts "2. List performances by venue"
  #   puts "3. List performances by month"
  #   puts "4. Go back"
  #   puts "5. Exit program"
  #   print "Enter a number: "
  #   input = gets.chomp.downcase
  #
  #   case input
  #   when "1" then list_all_performances
  #   when "2" then select_venue
  #   when "3" then select_month
  #   when "4" then search
  #   when "5" then exit
  #   else search_performances
  #   end
  # end
end
