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
    #return "data_hash" hash of :title, :days, :months, :times, :venue, :price, :duration, :composers, :pieces, :url
    doc = get_page(page_url)
    result = {}

    result[:title] = doc.search("div.small-12 div.mobblk h2").text
    result[:days] = []
    doc.search("div.iblock div.date-cont p.date").each {|day| result[:days] << day.text.strip}
    result[:months] = []
    doc.search("div.iblock div.date-cont p.month").each {|date| result[:months] << date.text.strip}
    result[:times] = []
    doc.search("div.iblock div.col33 h3").each {|time| result[:times] << time.text.strip}
    result[:composers] = []
    doc.search("div.grey-bg div.col1").each {|composer| result[:composers] << composer.text.strip}
    result[:pieces] = []
    doc.search("div.grey-bg div.col2").each {|piece| result[:pieces] << piece.text.strip}
    result[:url] = page_url

    doc.search("div.small-12 div.col33").each do |column|
      column_data = column.search("h5.teal").text.strip
      if column_data.include?("Location")
        result[:venue] = column.search("h2").text.strip
      elsif column_data.include?("Price Range")
        result[:price] = column.search("h2").text.strip
      elsif column_data.include?("Duration")
        result[:duration] = column.search("h2").text.strip
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
