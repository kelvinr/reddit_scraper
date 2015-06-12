require 'net/http'
require 'nokogiri'

class Scraper
  attr_accessor :posts, :url, :hiring

  def initialize(url)
    @url = URI(url)
    @posts = parse_data
    @hiring = []
  end

  def get_data
    response = Net::HTTP.start(url.host, use_ssl: true) do |http|
      request = Net::HTTP::Get.new(url)
      response = http.request(request).body
    end
  end

  def parse_data
    data = Nokogiri::HTML.parse get_data
    posts = data.css('a.title').select do |post|
      post.content.downcase.include?("ruby")
    end
  end

  def format
    old_links = ".old_links"
    File.new(old_links, "w") unless File.exists?(old_links)

    posts.select do |post|
      unless File.readlines(old_links).include?(post['href'])
        @hiring << {"#{post.content}" => post['href']}
        open(old_links, 'a'){|f| f.puts post['href']}
      end
    end
  end
end
