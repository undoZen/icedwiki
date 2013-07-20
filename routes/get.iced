app = require('../app.iced')
app.get '/*', (req, res, next) ->
  pathname = req._parsedUrl.pathname
  console.log(pathname)
  res.end(req.route.path)
