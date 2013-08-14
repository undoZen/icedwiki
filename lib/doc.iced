{Doc} = require('../models.iced')
marked = require('marked')
marked.setOptions({
  gfm: true,
  breaks: true,
})
_ = require('underscore')
{reflink} = require('../config.iced')

exports.put = (obj, cb) ->
  await Doc.findOne({slug: obj.slug}, defer(err, oldDoc))
  return cb(err) if err
  created_at = if oldDoc then oldDoc.created_at else Date.now()
  await Doc.update({slug: obj.slug}, {history: true}, {multi: true}, defer(err))
  return cb(err) if err
  obj = _.extend({created_at, modified_at: Date.now()}, obj)
  obj.html = marked(obj.content)
  obj.links_to = []
  obj.html.replace reflink, (all, title, slug) ->
    slug = '/' + slug if slug[0] isnt '/'
    obj.links_to.push(slug) if slug
  obj.html.replace /<h1>([^\n]+)<\/h1>/i, (all, title) ->
    obj.title = title
  obj.title ||= obj.slug
  (new Doc(obj)).save(cb)

getTitles = exports.getTitles = (slugs, cb) ->
  queryObj = {slug: {$in: slugs}, history: false}
  await Doc.find(queryObj).exec(defer(err, docs))
  return cb(err) if err
  result = {}
  _.each docs, (doc) ->
    result[doc.slug] = doc.title
  cb(null, result)

addInnerLink = exports.addInnerLink = (html, titles) ->
  html.replace reflink, (all, title, slug) ->
    slug = '/' + slug if slug[0] isnt '/'
    return '' if not title and not slug
    return title if not slug
    title = title or titles[slug] or slug.replace(/^\//,'')
    return '<a href="' + slug + '">' + title + '</a>'

exports.get = (queryObj, cb) ->
  queryObj = {slug: queryObj} if typeof queryObj is 'string'
  queryObj = _.pick(queryObj, 'slug', 'published')
  queryObj.history = false
  await Doc.findOne(queryObj, defer(err, doc))
  return cb(err) if err
  return cb(null, null) if not doc
  await getTitles(doc.links_to, defer(err, titles))
  doc.html = addInnerLink(doc.html, titles)
  cb(null, doc)
