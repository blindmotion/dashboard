class DataProvider
    getData: ->

class Data

class FileCsvLoader

    constructor: () ->
        @subscribers = []
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
