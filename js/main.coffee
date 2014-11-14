
onVideoTimeChanged = () ->
    videoNode = $('#player')
    timePlace = $('#time-place')
    videoTime = videoNode[0].currentTime
    
    if interval?
        date = new Date(interval.start.getTime() + Math.round(videoTime * 1000))
        date = moment(date)
        timePlace.text(date.format("HH:mm:ss"))

window.onVideoTimeChanged = onVideoTimeChanged
