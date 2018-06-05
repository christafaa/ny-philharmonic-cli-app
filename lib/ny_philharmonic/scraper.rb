class NyPhilharmonic::Scraper
  attr_accessor :concert_urls, :counter

  def initialize
    @counter = 0
  end

  def get_page(url)
    doc = Nokogiri::HTML(open(url))
  end

  def get_concert_urls
    link_objects = get_page("https://nyphil.org/calendar?season=all&page=all").search("div.cal-date div.col70 div a")
    concert_link_objects = link_objects.select {|link| link.text == "Event Details"}
    @concert_urls = concert_link_objects.map {|concert| concert["href"]}.uniq
  end

  def scrape_concert_page(page_url, counter)
    doc = get_page(page_url)
    data_hash = {
      :title => doc.search("div.small-12 div.mobblk h2").text,
      :days => doc.search("div.iblock div.date-cont p.date").map {|day| day.text.strip},
      :months => doc.search("div.iblock div.date-cont p.month").map {|date| date.text.strip},
      :times => doc.search("div.iblock div.col33 h3").map {|time| time.text.strip},
      :composers => doc.search("div.grey-bg div.col1").map {|composer| composer.text.strip},
      :pieces => doc.search("div.grey-bg div.col2").map {|piece| piece.text.strip},
      :url => page_url,
      :number => counter
    }

    doc.search("div.small-12 div.col33").each do |column|
      column_data = column.search("h5.teal").text.strip

      data_hash[:venue] = column.search("h2").text.strip if column_data.include?("Location")
      data_hash[:price] = column.search("h2").text.strip if column_data.include?("Price Range")
      data_hash[:duration] = column.search("h2").text.strip if column_data.include?("Duration")
    end
    data_hash
  end

  def create_concerts
    @concert_urls.slice!(0..4).map do |url|
      @counter += 1
      data_hash = scrape_concert_page("https://nyphil.org#{url}", @counter)
      NyPhilharmonic::Concert.new(data_hash)
    end
  end

  def create_new_page
    NyPhilharmonic::Page.new(create_concerts)
  end
end
