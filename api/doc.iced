{ Doc } = require('../models.iced')
marked = require('marked')
_ = require('underscore')
{ reflink } = require('../config.iced')

defaultDoc =
  auto_saved: false
  published: false

exports.put = (obj, cb) ->
  await Doc.findOne({ slug: obj.slug }, defer(err, oldDoc))
  return cb(err) if err
  created_at = if oldDoc then oldDoc.created_at else Date.now()
  await Doc.update({ slug: obj.slug }, { history: true }, defer(err))
  return cb(err) if err
  obj = _.extend({ created_at, modified_at: Date.now() }, defaultDoc, obj)
  obj.html = marked(obj.content)
  obj.links_to = []
  obj.html.replace reflink, (all, title, slug) ->
    slug = '/' + slug if slug[0] is not '/'
    obj.links_to.push(slug) if slug
  obj.html.replace /<h1>([^\n]+)<\/h1>/i, (all, title) ->
    obj.title = title
  obj.title ||= slug
  (new Doc(obj)).save(cb)

getTitles = exports.getTitles = (slugs, cb) ->
  queryObj = { slug: { $in: slugs }, history: false }
  await Doc.find(queryObj).exec(defer(err, docs))
  console.log(docs)
  return cb(err) if err
  result = {}
  _.each docs, (doc) ->
    result[doc.slug] = doc.title
  cb(null, result)

addInnerLink = exports.addInnerLink = (html, titles) ->
  html.replace reflink, (all, title, slug) ->
    return '' if not title and not slug
    return title if not slug
    title = title or titles[slug] or slug.replace(/^\//,'')
    return '<a href="' + slug + '">' + title + '</a>'

exports.get = (slug, cb) ->
  slug = slug.slug if slug.slug # -_-
  console.log({ slug, history: false })
  await Doc.findOne({ slug, history: false }, defer(err, doc))
  return cb(err) if err
  await getTitles(doc.links_to, defer(err, titles))
  doc.html = addInnerLink(doc.html, titles)
  cb(null, doc)
