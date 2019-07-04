require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    array_of_students = doc.css(".roster-cards-container .student-card")
    array_of_students.map do |student| 
      student_name = student.css(".student-name").text
      student_location = student.css(".student-location").text
      student_profile_url = student.css("a").attribute("href").value
      student_hash = {:name => student_name, :location => student_location, :profile_url => student_profile_url}
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    output_hash = {}
    doc.css(".social-icon-container a").map do |social_media_link| 
      link = social_media_link.attribute("href").value
      type = social_media_link.css("img").attribute("src").value.gsub("../assets/img/", "").gsub("-icon.png", "")
      if type == "rss" 
        output_hash[:blog] = link
      else
        output_hash[type.to_sym] = link
      end
    end
    
    output_hash[:bio] = doc.css(".details-container p").text
    output_hash[:profile_quote] = doc.css(".profile-quote").text
    output_hash
  end

end

