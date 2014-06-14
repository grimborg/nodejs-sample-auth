express = require 'express'
mongoose = require 'mongoose'
passport = require 'passport'
flash = require 'connect-flash'
morgan = require 'morgan'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
session = require 'express-session'

config = require './config'

app = express()
mongoose.connect config.db.url

app.use morgan('dev')
app.use cookieParser()
app.use bodyParser()

app.set 'view engine', 'ejs'

app.use session secret: 'test'
app.use passport.initialize()
app.use passport.session()
app.use flash()

(require './auth')(passport)
(require './app/routes')(app, passport)

app.listen(config.web.port)
console.log "listening to #{config.web.port}"

