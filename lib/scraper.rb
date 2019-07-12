require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    [].tap do |arr|
      doc.css(".student-card").each do |card|
        arr << {
          :name => card.css(".student-name").first.text,
          :location => card.css(".student-location").first.text,
          :profile_url =>  card.css("a").first.attributes["href"].value,
        }

      end
    end

  end

  def self.scrape_profile_page(profile_url)

  end

end

