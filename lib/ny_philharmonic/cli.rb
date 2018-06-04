class NyPhilharmonic::CLI
  def call
    puts "\nWelcome to The New York Philharmonic CLI App"
    puts "Loading concerts (this may take a moment)..."
    scraper = NyPhilharmonic::Scraper.new
    scraper.get_concert_urls
    scraper.create_five_concerts
    search
  end

  def search
    counter = 1
    puts "\nUpcoming concerts: "
    NyPhilharmonic::Concert.all.each do |concert|
      puts "\n#{counter}. #{concert.title}"
      puts "\tDates: #{concert.dates}"
      counter += 1
    end

    puts "Enter 'menu' to see a full list of commands"
    print "Enter a command: "
    input = gets.chomp.downcase

    case input
    when "menu" then menu
    when ">" then search_performances(month)
    when "<" then exit
    else
      puts "Please use one of these commands:"
      menu
    end
  end

  def menu

    puts "\nTo learn more about a concert, enter its number"
    puts "To scroll forward and view more concerts, enter '>'"
    puts "To scroll back and view previous concerts, enter '<'"

    puts "1. Search all performances"
    puts "2. Search performances by month"
    puts "3. Exit program"
    print "Enter a number: "
  end

  def search_performances
    system("clear")
    puts "--- Searching performances ---"
    puts "1. List all performances"
    puts "2. List performances by venue"
    puts "3. List performances by month"
    puts "4. Go back"
    puts "5. Exit program"
    print "Enter a number: "
    input = gets.chomp.downcase

    case input
    when "1" then list_all_performances
    when "2" then select_venue
    when "3" then select_month
    when "4" then search
    when "5" then exit
    else search_performances
    end
  end
end
