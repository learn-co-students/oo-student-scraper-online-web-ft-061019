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
    doc = Nokogiri::HTML(open(profile_url))

    my_hash = {}
    social_links = doc.css('.social-icon-container a').reject do |container|
      container.attributes["href"].value.nil?
    end

    social_links.each do |link|
      social_sym = [:twitter, :linkedin, :github]
      url = link.attributes["href"].value

      if URI.parse(url).host.split(".").include?("www")
         my_sym = URI.parse(url).host.split(".")[1].to_sym
      else
        my_sym = URI.parse(url).host.split(".")[0].to_sym
      end
      social_sym.include?(my_sym)? (my_hash[my_sym] = url) : (my_hash[:blog] = url)
    end

    my_hash[:profile_quote] = doc.css('div.profile-quote').text
    my_hash[:bio] = doc.css('.description-holder p').text

    my_hash

  end

end

