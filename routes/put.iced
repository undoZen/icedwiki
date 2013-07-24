{password} = require('../config.iced')
app = require('../app.iced')
api = require('../lib/index.iced')
_ = require('underscore')
app.put '/*', (req, res, next) ->
  if req.body.password isnt password
    res.statusCode = 403
    res.end()
    return
  slug = req._parsedUrl.pathname
  obj = _.extend({}, req.body, {slug})
  await api.doc.put(obj, defer(err, doc))
  return next(err) if err
  if req.accepts('json') or req.xhr
    res.setHeader('Content-Type', 'application/json; charset=utf-8')
    res.end('{"success": true}')
  else
    res.redirect(slug)
