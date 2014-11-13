[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/bscofield/river-guide)


# River Guide

Scrape a set of Amazon wishlists and email their contents, ordered cheapest to most expensive.

## Deploying

RG is meant to be deployed to Heroku and run as a daily or weekly process. To do that, clone the repo, then:

    $ heroku create
    $ heroku addons:add mailgun:starter
    $ heroku config:set RECIPIENT=[your email] IDS="[space separated list of wishlist IDs]"
    $ git push heroku master

## TODO
* use the history to identify items that have dropped in price
