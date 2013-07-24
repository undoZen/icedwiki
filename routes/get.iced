app = require('../app.iced')
api = require('../lib/index.iced')
{salt} = require('../config.iced')
app.get '/*', (req, res, next) ->
  slug = req._parsedUrl.pathname
  queryObj = {slug}
  if 'draft' not of req.query
    queryObj.published = true
  await api.doc.get(queryObj, defer(err, doc))
  doc = {html: 'not found', title: 'not found'} if not doc
  doc.title += ' - undozen.com'
  res.render('index', {doc, salt})
