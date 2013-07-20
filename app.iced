express = require('express')
path = require('path')

exports = module.exports = app = express()

# all environments
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use('/static', express.static(path.join(__dirname, 'public')))
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)

# development only
if ('development' == app.get('env'))
  app.use(express.errorHandler())

require('./routes/' + r + '.iced') for r in ['get', 'post']
