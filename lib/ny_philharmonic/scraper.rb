#only load 10 at a time
class NyPhilharmonic::Scraper

  def get_page(url)
    doc = Nokogiri::HTML(open(url))
  end

  def get_concert_urls
    link_objects = get_page("https://nyphil.org/calendar?season=18&page=all").search("div.cal-date div.col70 div a")
    #use this when done https://nyphil.org/calendar?season=all&page=all
    concert_link_objects = link_objects.select {|concert| concert.text == "Event Details"}
    concert_urls = concert_link_objects.map {|concert| concert["href"]}.uniq
  end

  def scrape_from_concert_page(page_url)
    #return "data_hash" hash of :title, :dates, :times, :url, :venue, :price, :duration, :description
    doc = get_page(page_url)
    result = {}

    result[:title] = doc.search("div.small-12 div.mobblk h2").text
    result[:dates] = []
    doc.search("div.iblock div.date-cont p.month").each {|date| result[:dates] << date.text}
    result[:times] = []
    doc.search("div.iblock div.col33 h3").each {|time| result[:times] << time.text}
    result[:url] = page_url
    #result[:program] = doc.search("")

    doc.search("div.small-12 div.col33").each do |column|
      column_data = column.search("h5.teal").text.strip
      if column_data.include?("Location")
        result[:venue] = column.search("h2").text
      elsif column_data.include?("Price Range")
        result[:price] = column.search("h2").text
      elsif column_data.include?("Duration")
        result[:duration] = column.search("h2").text
      end
    end
    result
  end

  def create_concerts
    get_concert_urls.each do |url|
      data_hash = scrape_from_concert_page("https://nyphil.org#{url}")
      #NyPhilharmonic::Concert.new(data_hash)
      puts data_hash
    end
  end

end
