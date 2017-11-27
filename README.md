[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/bscofield/river-guide)

# River Guide

Scrape a set of Amazon wishlists and email their contents, ordered cheapest to most expensive.

## Deploying

RG is meant to be deployed to Heroku and run as a daily or weekly process. Use the Deploy to Heroku button to get set up; then, open up the Heroku Scheduler add-on and create a task to run `bundle exec rake deliver` at the frequency you like.
