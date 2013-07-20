config = require('./config.iced')
mongoose = exports = module.exports = require('mongoose')
mongoose.connect(config.mongoUri)
mongoose.connection.on('error', console.error.bind(console, 'mongodb connection error:'))

