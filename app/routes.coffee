module.exports = (app, passport) ->
    app.get '/', (req, res) ->
        res.render 'index.ejs'

    app.get '/login', (req, res) ->
        res.render 'login.ejs', message: req.flash 'loginMessage'

    app.get '/signup', (req, res) ->
        res.render 'signup.ejs', message: req.flash 'signupMessage'

    app.get '/profile', isLoggedIn, (req, res) ->
        res.render 'profile.ejs', user: req.user

    app.get '/logout', (req, res) ->
        req.logout()
        res.redirect '/'

    app.post '/signup', passport.authenticate 'local-signup',
        successRedirect: '/profile'
        failureRedirect: '/signup'
        failureFlash: true

    app.get '/auth/google', (passport.authenticate 'google', scope: ['profile', 'email'])

    app.get '/auth/google/callback', 
        passport.authenticate 'google',
            successRedirect: '/profile'
            failureRedirect: '/'

    app.post '/login', passport.authenticate 'local-login',
        successRedirect: '/profile'
        failureRedirect: '/login'
        failureFlash: true

isLoggedIn = (req, res, next) ->
    if req.isAuthenticated()
        return next()
    res.redirect '/'
