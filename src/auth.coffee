http = require 'http'
fs   = require 'fs'
url  = require 'url'
open = require 'open'

# Open auth page
auth = (callback) ->
  if not tmp.userId or not tmp.token # TODO: if user change pass, I need another token
    open "https://oauth.vk.com/authorize?\
      client_id=#{config.vk.appId}&\
      scope=#{config.vk.permissions}&\
      display=page&\
      v=#{config.vk.version}&\
      response_type=token&\
      redirect_uri=http://127.0.0.1:8080/?do=getTokenHtml"

    http.createServer (req, res) ->
      query = url.parse(req.url, true).query

      switch query.do
        when 'getToken'
          tmp.userId = query.userId
          tmp.token  = query.token

          console.log 'Auth completed successfully.'

          callback()

          res.end()

        # Get token from html (this is bad solution (or govnokod (yeah, this is govnokod)))
        when 'getTokenHtml'
          fs.readFile __dirname + '/token.html', (e, html) ->
            if e
              console.error e

            res.writeHead 200, {'Content-Type': 'text/html'}
            res.write html
            res.end()
    .listen 8080