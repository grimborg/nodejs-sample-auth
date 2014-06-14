mongoose = require 'mongoose'
bcrypt = require 'bcrypt-nodejs'

userSchema = mongoose.Schema
    local:
        email: String
        password: String
    google:
        id: String
        token: String
        email: String
        name: String

userSchema.methods.generateHash = (password) ->
    bcrypt.hashSync password, bcrypt.genSaltSync 8, null

userSchema.methods.validPassword = (password) ->
    bcrypt.compareSync password, @local.password

module.exports = mongoose.model 'User', userSchema
