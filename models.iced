mongoose = require('./mongoose')
docSchema = mongoose.Schema
  slug: String
  title: String
  auto_saved: Boolean
  published: Boolean
  history: { type: Boolean, default: false }
  content: String
  html: String
  created_at: Date
  modified_at: { type: Date, default: Date.now }
  links_to: [String]

exports.Doc = mongoose.model('Doc', docSchema)
