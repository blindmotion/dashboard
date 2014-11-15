parse = require('csv-parse')
moment = require('moment')
coffeescript = require('coffee-script')

MsecInADay = 86400000

interval = null
chart = null

clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance
