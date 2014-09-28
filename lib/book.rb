require 'nokogiri'

require_relative 'database'

class Book
  attr_reader :row

  def initialize(row)
    @row = row
  end

  def title_cell
    @title_cell ||= row.css('td.g-title')
  end

  def title_link
    @title_link ||= title_cell.css('h5')
  end

  def url
    'https://www.amazon.com' + title_link.attribute('href').text.strip
  rescue
    ''
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
      url:   url
    }
  end

  def display_price
    sprintf("%0.02f", price)
  end

  def to_s
    [display_price, "<a href=\"#{url}\">#{title}</a>"].join(' / ')
  end

  def to_screen
    [display_price, title].join(' / ')
  end
end
