require 'open-uri'
require 'nokogiri'

require_relative 'book'
require_relative 'mailer'
require_relative 'database'

class Scraper
  URL =
  'http://www.amazon.com/gp/registry/wishlist/ref=cm_wl_act_print_o?ie=UTF8&disableNav=1&filter=all&id=_ID_&items-per-page=200&layout=standard-print&sort=universal-price'

  def self.deliver(ids)
    books = scrape(ids)

    sorted_drops = Database.find_drops(books).sort! {|x,y| x.price <=> y.price}
    sorted_books = (books - sorted_drops).sort! {|x,y| x.price <=> y.price}

    Database.save(books)
    Mailer.send(sorted_drops, sorted_books)
  end

  def self.scrape(ids)
    ids.map do |id|
      puts "Retrieving list #{id}"
      doc  = Nokogiri::HTML(open(URL.sub(/_ID_/, id)))
      rows = doc.css('table.g-print-items tr')
      rows.shift
      rows.map {|r| Book.new(r)}
    end.flatten
  end
end
