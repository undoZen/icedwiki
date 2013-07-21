module.exports =
  mongoUri: process.env.MONGOLAB_URI or
    process.env.MONGOHQ_URL or
    'mongodb://localhost/icedwiki'
  reflink: /\[((?:\[[^\]]*\]|[^\]]|\](?=[^\[]*\]))*)\]\s*\[([^\]]*)\]/g
