# Copyright (c) 2014, Blind Motion Project
# All rights reserved.

parse = require('csv-parse')
moment = require('moment')
coffeescript = require('coffee-script')

MsecInADay = 86400000

KeyCodes = {
    'a' : 65,
    's' : 83,
    'd' : 68,
    'w' : 87,
    'e' : 69,
    'r' : 82,
    '0' : 48,
    '1' : 49,
    '2' : 50,
    '3' : 51,
    '4' : 52,
    '5' : 53,
    '6' : 54,
    '7' : 55,
    '8' : 56,
    '9' : 57,
    '[' : 219,
    ']' : 221,
    'enter' : 13,
    'esc' : 27
}

EventName = {
    1: 'Line change',
    2: 'Obstacle avoidance',
    3: 'Overtake',
    4: '45-turn',
    5: '90-turn',
    6: '180-turn',
    0: 'Dirty data'
}

DirectionName = {
    0: 'left',
    1: 'right'
}

interval = null
chart = null
currentDate = null
currentFileNameBase = null
allEvents = null

clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance
