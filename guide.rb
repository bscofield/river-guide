require 'bundler'
Bundler.setup

require 'open-uri'
require 'nokogiri'

class Row
  attr_reader :row

  def initialize(row)
    @row = row
  end

  def title_cell
    @title_cell ||= row.css('td.g-title')
  end

  def title_link
    @title_link ||= title_cell.css('a')
  end

  def url
    'https://www.amazon.com' + title_link.attribute('href').text.strip
  end

  def title
    title_link.text.strip
  end

  def price
    cell = row.css('td.g-price')
    cell.text.strip.sub(/\$/, '').to_f
  end

  def to_hash
    {
      title: title,
      price: price,
      url: url
    }
  end

  def to_s
    [price, "<a href=\"#{url}\">#{title}</a>"].join(' / ')
  end
end


url = 'http://www.amazon.com/gp/registry/wishlist/_ID_?layout=compact&sort=universal-price'

ids = ENV['IDS'].split(' ')

books = ids.map do |id|
  puts "Retrieving list #{id}"
  doc = Nokogiri::HTML(open(url.sub(/_ID_/, id)))
  rows = doc.css('table.g-compact-items tr')
  rows.shift
  rows.map {|r| Row.new(r)}
end.flatten

for_consumption = books.sort! {|x,y| x.price <=> y.price}.map(&:to_s)

require 'mail'
Mail.defaults do
  delivery_method :smtp, port: ENV['MAILGUN_SMTP_PORT'],
                         address: ENV['MAILGUN_SMTP_SERVER'],
                         domain: 'example.com',
                         user_name: ENV['MAILGUN_SMTP_LOGIN'],
                         password: ENV['MAILGUN_SMTP_PASSWORD'],
                         authentication: :plain
end

Mail.deliver do
  from     'river-guide@example.com'
  to       ENV['RECIPIENT']
  subject  "River Guide for #{Time.now.strftime('%-d %B')}"
  html_part do
    content_type 'text/html; charset=UTF-8'
    body         for_consumption.join('<br>')
  end
end
