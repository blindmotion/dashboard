class Observer
    constructor: () ->
        @events = {}

    bind : (event, fn) ->
        @events[event] ?= []
        @events[event].push fn

    unbind: (event, fn) ->
        if @events[event]?.indexOf(fn) >= 0
            @events[event]?.splice @events[event].indexOf(fn), 1

    trigger: (event, args...) ->
        if @events[event]
            for callback in @events[event] when callback
                callback.apply @, args
