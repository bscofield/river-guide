# River Guide

Scrape a set of Amazon wishlists and email their contents, ordered cheapest to most expensive.

## Deploying

RG is meant to be deployed to Heroku and run as a daily or weekly process. To do that, clone the repo, then:

    $ heroku create
    $ heroku addons:add mailgun:starter
    $ heroku config:set RECIPIENT=[your email] IDS="[space separated list of wishlist IDs]"
    $ git push heroku master
