require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open("./fixtures/student-site/index.html"))
    students = []
    doc.css("div.roster-cards-container").each do |card|
      card.css("div.student-card a").each do |student|
        student_name = student.css("div.card-text-container h4").text
        student_location = student.css("div.card-text-container p").text
        student_url = student.first[1]
        students << {location: student_location, name: student_name, profile_url: student_url}
      end
    end  
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    doc = Nokogiri::HTML(open(profile_url))
    student[:bio] = doc.css("div.bio-content.content-holder div.description-holder p").text
    student[:profile_quote] = doc.css("div.profile-quote").text
    social_links = doc.css("div.social-icon-container a").map { |link| link['href'] }
    social_links.each do |link|
      if link.include?("twitter") 
        student[:twitter] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      else
        student[:blog] = link
      end
    end
    student
  end

end

