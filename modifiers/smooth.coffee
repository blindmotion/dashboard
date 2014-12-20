smoothRadius = 4

smooth = (arr, result) =>
    l = arr.length
    for i in [0..(l-1)]
        elCopy = []
        for e in arr[i]
            elCopy.push(e)
        
        elCopy[3] = 0
        elCopy[4] = 0
        elCopy[5] = 0
        tempCount = 0
        
        il = i-smoothRadius
        if il < 0
            il = 0
            
        while il <= i + smoothRadius && il < arr.length
            elCopy[3] += arr[il][3]
            elCopy[4] += arr[il][4]
            elCopy[5] += arr[il][5]
            tempCount++
            il++
            
        elCopy[3] /= tempCount
        elCopy[4] /= tempCount
        elCopy[5] /= tempCount
            
        result.push(elCopy)

window.dataPreprocessor = (data) =>
    aAcc = []
    aGyr = []
    aGeo = []
    
    #split data to different arrays
    for el in data
        switch el[0]
            when 1 #accelerometer
                elCopy = []
                for e in el
                    elCopy.push(e)
                
                aAcc.push(elCopy)
                
            when 4 #gyroscope
                elCopy = []
                for e in el
                    elCopy.push(e)
                
                aGyr.push(elCopy)
                
            when 'geo' #geodata
                elCopy = []
                for e in el
                    elCopy.push(e)
                
                aGeo.push(elCopy)
    
    result = []
    result = result.concat(aGeo)
    
    #smooth data
    smooth(aAcc, result)
    smooth(aGyr, result)

    return result