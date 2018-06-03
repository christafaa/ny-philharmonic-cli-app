class NyPhilharmonic::CLI
  def call
    system("clear")
    puts "Welcome to The New York Philharmonic CLI App"
    puts "What would you like to do?"
    puts "1. Search all performances"
    puts "2. Search performances by month"
    puts "3. Exit program"
    print "Enter a number: "
    input = gets.chomp.downcase

    case input
    when "1" then search_performances
    when "2" then search_performances(month)
    when "3" then exit
    else call
    end
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
    when "4" then call
    when "5" then exit
    else search_performances
    end
  end
end
