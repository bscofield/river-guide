require 'bundler'
Bundler.setup

require_relative 'lib/scraper'

require 'pp'

desc 'Scrape Amazon and display the results'
task :scrape do
  books = Scraper.scrape(ENV['IDS'].split(' '))
  pp books.map(&:to_screen)
end

desc 'Scrape Amazon and send the summary email'
task :deliver do
  Scraper.deliver(ENV['IDS'].split(' '))
end

desc 'Create the database'
task :create_db do
  Database.setup
end
