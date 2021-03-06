[![Build Status](https://travis-ci.org/openhealthcare/cedar.svg?branch=master)](https://travis-ci.org/openhealthcare/cedar)

Something somewhere between [this](http://xkcd.com/518/), IFTTT and Yahoo Pipes, right? I mean eventually, not right now. And more the former than the latter.


To be easy to create rules, easy to tie them together and take data from the local data you’ve got, as well as potentially external sources. JSON in, JSON out.

### Install

To start your CEDAR application you have to:

1. Install dependencies with `mix deps.get`
3. Start Phoenix router with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.


### To manage the audit log

#### Purge

```mix audit purge```

#### Compress

```mix audit archive```

### Email settings

In order to actually send emails with MAILGUN, you'll need to set the
```MAILGUN_KEY``` environment variable to your API key.
