###
# App definition
# @namespace Node
# @module Node
###

###
# @memberOf Node
# @method app.definition
###

express = require 'express'
path 	= require 'path'
favicon = require 'serve-favicon'
logger 	= require 'morgan'
colors  = require 'colors'
compression     = require 'compression'
cookieParser 	= require 'cookie-parser'
bodyParser 		= require 'body-parser'

config = require './config'
console.log config
# process.env.NODE_ENV = 'production';
# mailer      = require './util/mailer'

port = process.env.PORT || 3000
app  = express()
app.locals.moment = require 'moment'

# DB conection
mongoose = require 'mongoose'
mongoose.connect config.mongodb


# view engine setup
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'


# Configuracion Passport
user           = require './models/userModel'
passport       = require 'passport'
LocalStrategy  = require('passport-local').Strategy
expressSession = require 'express-session'
MongoStore     = require('connect-mongo')(expressSession)
app.use(expressSession({
    secret: 'ToleranceSecretKey'
    resave: false,
    saveUninitialized: true,
    store : new MongoStore({
                    url: 'mongodb://localhost/tolerant',
                    ttl: 1 * 24 * 60 * 60  # = 1 days. Default 
                })
}));
app.use passport.initialize()
app.use passport.session()
passport.use new LocalStrategy(user.authenticate())
passport.serializeUser user.serializeUser()
passport.deserializeUser user.deserializeUser()


app.use(compression())
# uncomment after placing your favicon in /public
app.use favicon(path.join(__dirname, 'public','favicon.ico'))
app.use logger 'dev'
# , { skip: (req, res)-> return res.statusCode < 400 }
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false
app.use cookieParser()
app.use express.static path.join __dirname, 'public'


# ROUTES
home    = require './routes/index'
account = require './routes/account'
users   = require './routes/users'
producto= require './routes/producto'
comercio= require './routes/comercio'
find    = require './routes/find'

app.use '/',        home
app.use '/account', account
app.use '/users',   users
app.use '/producto',producto
app.use '/comercio',comercio
app.use '/find',    find


# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err


# ERROR HANDLERS

# development error handler
# will print stacktrace
# console.log app.get('env')
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        console.log err.status
        res.status err.status or 500
        res.render 'error',
            message: err.message,
            error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
        message: err.message,
        error: err

app.once 'listened', ->
    db = mongoose.connection
    db.on('error', (err)->  colors.red('connection error: ' + err)      )
    db.once('open', (mdb)-> console.log colors.cyan("we're connected to: " + db.name + ", on port: " + port) )

module.exports = app
