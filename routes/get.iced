_ = require('underscore')
app = require('../app.iced')
api = require('../lib/index.iced')
{salt} = require('../config.iced')
app.get '/*', (req, res, next) ->
  slug = req._parsedUrl.pathname
  queryObj = {slug}
  await api.doc.get(queryObj, defer(err, doc))
  notFoundDoc = {html: 'not found', title: 'not found'}
  doc = _.extend(
    {},
    doc or {},
    if doc and doc.published then {} else notFoundDoc
  )
  doc.title += ' - undozen.com'
  res.render('index', {doc, salt})
