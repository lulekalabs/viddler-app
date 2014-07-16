# Viddler App

Prototype to show video upload and recording of viddler.com using Rails 3.1.

The app is live on http://fierce-meadow-8231.heroku.com



## Installation

    bundle install
    rake db:migrate
    rake db:seed

## Deployment

    git push heroku master
    heroku rake db:migrate
    heroku rake db:seed
    heroku logs
