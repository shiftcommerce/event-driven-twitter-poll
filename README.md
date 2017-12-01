[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/shiftcommerce/event-driven-twitter-poll)

### Deployment instructions

1. [Create a Twitter app](https://apps.twitter.com/), creating an access token whilst you're at it
2. Click the Heroku deploy button above
3. Complete the deployment form with the Twitter app consumer key/secret and access token/secret
4. Tweet including your chosen TWITTER_STREAM_TERM and one of the TWITTER_STREAM_VOTE_TERMS

### Overview

This application listens on the Twitter stream for a chosen keyword, it then analyses the tweets for whether they contain configured voting terms and tallies the votes over time.

There is a web UI served by [Sinatra](http://sinatrarb.com/) which displays the votes as they come in using [Pusher](https://pusher.com/).
