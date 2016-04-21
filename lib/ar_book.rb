require_relative 'environment'

class ArBook < ActiveRecord::Base
  attr_accessor :book

  scope :drops, -> { where('last_price > current_price') }
  scope :undrops, -> { where('last_price <= current_price') }
  scope :sorted, -> { order('current_price ASC') }
  scope :current, ->(now) { where('last_seen > ?', now - 1.days) }

  def self.load(book)
    record = find_or_initialize_by(title: book.title)

    record.last_price = record.current_price
    record.current_price = book.price
    record.max_price = book.price if record.max_price.nil? || record.max_price < record.current_price
    record.last_seen = Time.now
    record.save
    record
  end

  def to_hash
    {
      title: title,
      price: price,
    }
  end

  def display_price
    if max_price.to_f > current_price.to_f
      diff = 100 * ((max_price.to_f - current_price.to_f) / max_price.to_f)
      "#{sprintf("%0.02f", current_price)} (#{sprintf("%0.02f", diff)}%)"
    else
      sprintf("%0.02f", current_price)
    end
  end

  def to_s
    [display_price, "<a href=\"#{url}\">#{title}</a>"].join(' / ')
  end

  def to_screen
    [display_price, title].join(' / ')
  end
end
