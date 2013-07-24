exports.sha512 = (string) ->
  sha512sum = require('crypto').createHash('sha512')
  sha512sum.update(string, 'utf8')
  return sha512sum.digest('hex')
