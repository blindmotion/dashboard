md5 = require('MD5');
parse = require('csv-parse')

excelTimeToDate = (excelTime) ->
    unixtime = (excelTime - 25569) * 86400

    # dirty hack, don't repeat it at home
    # Data Recorder for android writes data in local time, not UTC and with
    # no mention about timezone
    # TODO: make some workaround in the future
    unixtime -= 180 * 60

    date = new Date(unixtime*1000)
    return date
