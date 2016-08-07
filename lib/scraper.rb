require 'open-uri'
require 'nokogiri'

require_relative 'book'
require_relative 'ar_book'
require_relative 'mailer'

class Scraper
  URL =
  'https://www.amazon.com/gp/registry/wishlist/ref=cm_wl_act_print_o?ie=UTF8&disableNav=1&filter=all&id=_ID_&items-per-page=200&layout=standard-print&sort=universal-price'

  def self.deliver(ids)
    books = scrape(ids)

    ArBook.clear_unless(books)

    all_books = ArBook.current(Time.now).sorted
    new_drops = ArBook.current(Time.now).drops.sorted
    old_drops = ArBook.current(Time.now).old_drops.sorted

    Mailer.send(new_drops, old_drops, (all_books - old_drops - new_drops))
  end

  def self.scrape(ids)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

    puts "Beginning scrape..."
    ids.shuffle.map do |id|
      sleep rand(15)+15
      puts "Retrieving list #{id}"
      doc  = Nokogiri::HTML(open(URL.sub(/_ID_/, id), 'User-Agent' => user_agent))
      rows = doc.css('table.g-print-items tr')
      rows.shift
      rows.map { |r| ArBook.load(Book.new(r)) }
    end.flatten
  end
end
