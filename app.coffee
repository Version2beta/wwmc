# https://github.com/nko4/website/blob/master/module/README.md#nodejs-knockout-deploy-check-ins
require('nko')('cgtyi6pwUp5CEM0E')

express = require 'express'

isProduction = process.env.NODE_ENV == 'production'
port = if isProduction then 80 else 8000

app = express()
app.use express.static "#{__dirname}/public"

app.listen port, (err) ->
  if err
    console.error err
    process.exit -1

  console.log 'Server running at http://0.0.0.0:' + port + '/'

  # if run as root, downgrade to the owner of this file
  if process.getuid() is 0
    require('fs').stat __filename, (err, stats) ->
      return console.error(err)  if err
      process.setuid stats.uid
