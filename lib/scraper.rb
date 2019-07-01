require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :students

  def self.scrape_index_page(index_url)
    scrape_url = Nokogiri::HTML(open(index_url)).css(".student-card")
    students = []
    scrape_url.collect do |student_card|
      students << {
        :name => student_card.css("h4.student-name").text,
        :location => student_card.css("p.student-location").text, 
        :profile_url => student_card.css("a").attribute("href").value
      }
    end
    students
  end
  

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page =  Nokogiri::HTML(open(profile_url))
    scrape_page = profile_page.css("div.social-icon-container a").map{|zelda|zelda.attribute('href').value}
    scrape_page.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else 
        student[:blog] = link
    end
  end
  student[:profile_quote] = profile_page.css("div.profile-quote").text
  student[:bio] = profile_page.css("div.bio-content div.description-holder p").text
  student  
  end
end

