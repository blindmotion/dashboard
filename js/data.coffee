# Copyright (c) 2014, Blind Motion Project 
# All rights reserved.

getDataFromFile = (event, callback) ->
    file = event.target.files[0]

    onData = (event) ->
        data = event.target.result
        callback(data)

    reader = new FileReader()
    reader.addEventListener 'load', (event) => onData(event)
    reader.readAsText(file)

window.getDataFromFile = getDataFromFile

class FileCsvLoader

    constructor: () ->
        @data = null
        @obs = new Observer()

    onDataParsed: (err, array) ->
        @trigger('load', err, array)

    onData: (event) ->
        data = event.target.result
        options = {delimiter: ';', auto_parse: true}
        parse(data, options, (args...) => @onDataParsed(args...) )

    loadFromFile: (event) ->
        file = event.target.files[0]

        reader = new FileReader()
        reader.addEventListener 'load', (event) => @onData(event)
        reader.readAsText(file)

    bind: (event, fn) => @obs.bind(event, fn)
    unbind: (event, fn) => @obs.unbind(event, fn)
    trigger: (event, args...) => @obs.trigger(event, args...)

window.fileLoader = new FileCsvLoader()

class FileSelectorManager
    constructor: (inputElementId, labelElementId) ->
        if inputElementId == undefined || labelElementId == undefined
            throw new Error('Wrong arguments')

        @obs = new Observer()
        @inputElement = $('#' + inputElementId)
        @labelElement = $('#' + labelElementId)

        @inputElement.change( @onFileSelected )

    onFileSelected: (event) =>
        filename = @inputElement.val().replace(/\\/g, '/').replace(/.*\//, '');

        @trigger('change', @inputElement.get()[0], event)
        @labelElement.val(filename)

    bind: (event, fn) => @obs.bind(event, fn)
    unbind: (event, fn) => @obs.unbind(event, fn)
    trigger: (event, args...) => @obs.trigger(event, args...)

window.FileSelectorManager = FileSelectorManager

getIntervalFromSrt = (str) ->
    patt = new RegExp("[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}\:[0-9]{2}\:[0-9]{2}", "g");

    startStr = patt.exec(str)
    if startStr == null
        return null

    current = startStr

    while current != null
        endStr = current
        current = patt.exec(str)

    startStr = startStr[0].split(' ')[1]
    endStr = endStr[0].split(' ')[1]

    start = moment(startStr, 'HH:mm:ss').toDate()
    end = moment(endStr, 'HH:mm:ss').toDate()

    start = new Date(start.getTime() % MsecInADay)
    end = new Date(end.getTime() % MsecInADay)

    return {start: start, end: end}

window.getIntervalFromSrt = getIntervalFromSrt
