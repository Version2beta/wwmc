# https://github.com/nko4/website/blob/master/module/README.md#nodejs-knockout-deploy-check-ins
require('nko')('cgtyi6pwUp5CEM0E')
mongoose = require 'mongoose'

dbHost = process.env.DB_HOST ? 'localhost'

mongoose.connect "mongodb://#{dbHost}:27017/wwmc"

isProduction = process.env.NODE_ENV == 'production'
port = if isProduction then 80 else 8000

module.exports = {
  PORT: port
}

console.log "Connecting to db: #{dbHost}"
