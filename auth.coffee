LocalStrategy = (require 'passport-local').Strategy
GoogleStrategy = (require 'passport-google-oauth').OAuth2Strategy

config = require './config'
User = require './models/user'

module.exports = (passport) ->
    passport.serializeUser (user, done) ->
        done(null, user.id)

    passport.deserializeUser (id, done) ->
        User.findById id, (err, user) ->
            done err, user

    passport.use 'local-signup', new LocalStrategy
        usernameField: 'email'
        passwordField: 'password'
        passReqToCallback: true
        ,
        (req, email, password, done) ->
            process.nextTick ->
                User.findOne 'local.email': email, (err, user) ->
                    if err
                        return done err

                    if user
                        return done null, false, (req.flash 'signupMessage', 'The mail is already registered')
                    
                    newUser = User()
                    newUser.local.email = email
                    newUser.local.password = newUser.generateHash(password)

                    newUser.save (err) ->
                        if err
                            throw err
                        done null, newUser

    passport.use 'local-login', new LocalStrategy
        usernameField: 'email'
        passwordField: 'password'
        passReqToCallback: true
        ,
        (req, email, password, done) ->
            User.findOne 'local.email': email, (err, user) ->
                if err
                    return done err

                if not user
                    return done null, false, req.flash 'loginMessage', 'No user found'

                if not user.validPassword(password)
                    return done null, false, req.flash 'loginMessage', 'Wrong password'

                return done null, user

    passport.use new GoogleStrategy
        clientID: config.auth.google.id
        clientSecret: config.auth.google.secret
        callbackURL: config.auth.google.callbackURL
        ,
        (token, refreshToken, profile, done) ->
            process.nextTick ->
                User.findOne 'google.id': profile.id, (err, user) ->
                    if err
                        return done err
                    console.log "here #{profile.id} #{user}"
                    if user
                        return done null, user
                    else
                        newUser = User()
                        newUser.google.id = profile.id
                        newUser.google.token = token
                        newUser.google.name = profile.displayName
                        newUser.google.email = profile.emails[0].value

                        newUser.save (err) ->
                            if err
                                throw err
                            return done null, newUser