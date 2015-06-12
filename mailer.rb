require 'net/smtp'
require 'yaml'

class Mailer
  attr_reader :smtp, :account, :password, :links

  CREDS = YAML.load_file("/home/kelvin/Creds/mailer.yml")

  def initialize
    @smtp = Net::SMTP.new 'smtp.gmail.com', 587
    @account = CREDS['account']
    @password = CREDS['password']
    @smtp.enable_starttls
  end

  def send(email)
    smtp.start('reddit@scraper.com', account, password, :login) do
      smtp.send_message("test message", "New Posts", email)
    end
  end
end
