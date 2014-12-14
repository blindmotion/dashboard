# Copyright (c) 2014, Blind Motion Project
# All rights reserved.

PlayControlGroup = ['label-capture', 'label-back', 'label-forw', 'label-play']
AllEntriesControlGroup = ['label-export', 'label-reset']
LeftPanelGroup = PlayControlGroup.concat(AllEntriesControlGroup)

EventTypeGroup = ['label-line', 'label-avoid', 'label-overtake', 'label-45t',
    'label-90t', 'label-180t']
DirectionGroup = ['label-left', 'label-right']
EntryControlGroup = ['label-save', 'label-cancel']
RightPanelGroup = EventTypeGroup.concat(DirectionGroup).concat(EntryControlGroup)

LeftRightPanelGroup = LeftPanelGroup.concat(RightPanelGroup)

Directions =
    left: 0
    right: 1

defaultClasses = {}

capture = false
selectedEvent = null
selectedDirection = null
eventTimeStart = null
eventTimeEnd = null
events = []

window.initControlPanel = () ->
    for id in LeftRightPanelGroup
        defaultClasses[id] = $('#' + id).attr('class')

    setKeyboard()

    setVisible(['label-capture', 'label-back', 'label-forw', 'label-play'])
    setHidden(['label-export', 'label-reset'])
    setHidden(RightPanelGroup)

setVisible = (ids) ->
    for id in ids
        $('#' + id).css('visibility', 'visible')

setHidden = (ids) ->
    for id in ids
        $('#' + id).css('visibility', 'hidden')

setSelected = (ids) ->
    for id in ids
        $('#' + id).attr('class', 'label label-primary')

setNotSelected = (ids) ->
    for id in ids
        $('#' + id).attr('class', defaultClasses[id])

onEventSelected = (id) ->
    selectedEvent = id
    setNotSelected(EventTypeGroup)
    setVisible(DirectionGroup)

onDirectionSelected = (dir) ->
    selectedDirection = dir
    setNotSelected(DirectionGroup)
    setVisible(['label-save'])

downloadFile = (data) ->
    a = document.createElement("a")
    document.body.appendChild(a)
    a.style = "display: none"

    blob = new Blob([data], {type: "octet/stream"})
    url = window.URL.createObjectURL(blob)

    a.href = url
    a.download = window.currentFileNameBase + '.json'
    a.click()
    window.URL.revokeObjectURL(url)


setKeyboard = () ->
    videoNode = document.getElementById('player')
    $(window).keydown( (e) =>
        if e.target.nodeName.toLowerCase() == 'body'
            switch e.keyCode
                when KeyCodes['s']
                    if videoLoaded
                        if videoNode.paused
                            videoNode.play()
                        else
                            videoNode.pause()
                when KeyCodes['a']
                    if videoLoaded
                        videoNode.currentTime -= 3
                when KeyCodes['d']
                    if videoLoaded
                        videoNode.currentTime += 3
                when KeyCodes['w']
                    if videoLoaded && srtLoaded && !capture
                        capture = true
                        setVisible(EventTypeGroup)
                        setSelected(['label-capture'])
                        setVisible(['label-cancel'])
                        eventTimeStart = currentDate
                when KeyCodes['1']
                    if capture
                        onEventSelected(1)
                        setSelected(['label-line'])
                when KeyCodes['2']
                    if capture
                        onEventSelected(2)
                        setSelected(['label-avoid'])
                when KeyCodes['3']
                    if capture
                        onEventSelected(3)
                        setSelected(['label-overtake'])
                when KeyCodes['4']
                    if capture
                        onEventSelected(4)
                        setSelected(['label-45t'])
                when KeyCodes['5']
                    if capture
                        onEventSelected(5)
                        setSelected(['label-90t'])
                when KeyCodes['6']
                    if capture
                        onEventSelected(6)
                        setSelected(['label-180t'])
                when KeyCodes['[']
                    if selectedEvent != null
                        onDirectionSelected(Directions.left)
                        setSelected(['label-left'])
                when KeyCodes[']']
                    if selectedEvent != null
                        onDirectionSelected(Directions.right)
                        setSelected(['label-right'])
                when KeyCodes['esc']
                    if capture
                        setNotSelected(RightPanelGroup)
                        setHidden(RightPanelGroup)
                        setNotSelected(['label-capture'])
                        selectedEvent = null
                        selectedDirection = null
                        capture = false
                when KeyCodes['enter']
                    eventTimeEnd = currentDate

                    if selectedDirection != null
                        event = {
                            type: selectedEvent,
                            direction: selectedDirection,
                            start: moment(eventTimeStart).format("HH:mm:ss"),
                            end: moment(eventTimeEnd).format("HH:mm:ss")
                        }
                        events.push(event)

                        setNotSelected(RightPanelGroup)
                        setHidden(RightPanelGroup)
                        setNotSelected(['label-capture'])
                        selectedEvent = null
                        selectedDirection = null
                        capture = false

                        setVisible(AllEntriesControlGroup)
                when KeyCodes['e']
                    if events.length > 0
                        downloadFile(JSON.stringify(events))

                        setNotSelected(LeftRightPanelGroup)
                        setHidden(LeftRightPanelGroup)
                        selectedEvent = null
                        selectedDirection = null
                        capture = false
                        events = []

                        setVisible(PlayControlGroup)
                when KeyCodes['r']
                    if events.length > 0
                        setNotSelected(LeftRightPanelGroup)
                        setHidden(LeftRightPanelGroup)
                        selectedEvent = null
                        selectedDirection = null
                        capture = false
                        events = []

                        setVisible(PlayControlGroup)

    )
