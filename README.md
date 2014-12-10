To better understand what's going on we need a convenient tool to view both videos and telemetry data. It contains video view and line charts with data. 

![](https://github.com/blindmotion/docs/blob/master/pics/dashboard.png)

At first you need to select a csv data file in the format specified in the [wiki](//github.com/blindmotion/docs/wiki/Csv-file-format) page. We create this csv file with the [Sensor Recording](https://play.google.com/store/apps/details?id=net.braun_home.sensorrecording.pro) program for android.

The data is loaded and will be kept in memory until you upload other csv file.

The chart will show data as soon as you upload srt (Subtitles file) for the video. It will only display the data for the period of video. To show video itself, upload video file that corresponds to the srt file uploaded.

Once everything is set up you can now view video and data for it. Double clicking on chart will play video at the very same moment, where the chart was clicked. You can zoom and scroll chart as you wish.

Additionaly you are able to create a preprocessor for the data if you wish to display say moving average of the gyroscope sensor. You cannot modify the number of axes displayes: x,y,z for accelerometer and gyroscope and one axis for speed, but you can change the values of those axis.
The preprocessor will get only data for the interval selected. It is programmed in [CoffeeScript](http://coffeescript.org/).

A preprocessor example (multiplies all accelerometer values by 1.5 and gyro by 1.2):

``` coffeescript
window.dataPreprocessor = (data) =>
    for el in data

        switch el[0]
            when 1 #accelerometer
                el[3] = el[3] * 1.5 #x
                el[4] = el[4] * 1.5 #y
                el[5] = el[5] * 1.5 #z
            when 4 #gyroscope
                el[3] = el[3] * 1.2 #x
                el[4] = el[4] * 1.2 #y
                el[5] = el[5] * 1.2 #z
            when 'geo' #geodata
                el[9] = el[9] / 2 #speed
                    
    return data
```

Dashboard should work in any modern browser, however we recommend to use browser on the base of Chromium because it works faster.