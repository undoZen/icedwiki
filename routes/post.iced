app = require('../app.iced')
app.post '/*', (req, res, next) ->
  console.log req.body
  res.end(req.route.path)
