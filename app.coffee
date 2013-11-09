express = require 'express'
stylus = require 'stylus'
nib = require 'nib'
coffeescript = require 'connect-coffee-script'

milestone = require './controllers/milestone'
config = require './config'

isProduction = process.env.NODE_ENV == 'production'
port = if isProduction then 80 else 8000

app = express()

app.use coffeescript
  src: "#{__dirname}/public"
  bare: true

app.use stylus.middleware
  src: "#{__dirname}/public"
  compile: (str, path) ->
    stylus(str)
      .include("#{__dirname}/public")
      .use(nib())
      .set('filename', path)


app.use express.static "#{__dirname}/public"

app.get '/milestones', milestone.getMilestones
app.get '/milestones/:ids', milestone.getMilestonesById # comma-separated list of ids

app.listen config.PORT, (err) ->
  if err
    console.error err
    process.exit -1

  console.log 'Server running at http://0.0.0.0:' + config.PORT + '/'
