Sample Authentication with ExpressJS and Passport
=================================================

This is a sample ExpressJS application that shows how to implement user authentication using Passport.

The following strategies are implemented:

- Local (username/password)
- Google Plus

For more information, check out the excellent tutorials at [scotch.io](http://scotch.io/).

Configuration
-------------

Copy `config.coffee.sample` to `config.coffee` and add your credentials.


MongoDB
-------

This application stores the users in MongoDB. You can start up MongoDB quickly using [Docker](http://docker.io):

    docker run -d -p 27017:27017 dockerfile/mongodb
