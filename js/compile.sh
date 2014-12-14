#!/bin/sh
cat common.coffee observer.coffee data.coffee chart.coffee controlpanel.coffee main.coffee | coffee --compile --stdio > compiled/out.js 
browserify compiled/out.js > compiled/deps.js
