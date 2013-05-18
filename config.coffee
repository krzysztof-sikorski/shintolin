module.exports =
  port: process.env.PORT or 3000
  session_secret: process.env.SESSION_SECRET or 'secret'
  mongo_uri: process.env.MONGOLAB_URI or 'mongodb://localhost/shintolin'

  maximum_level: 18
  default_terrain: 'wilderness'

  production: process.env.NODE_ENV is 'production'
