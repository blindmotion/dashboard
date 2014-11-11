#!/bin/sh
cat common.coffee observer.coffee data.coffee chart.coffee | coffee --compile --stdio > compiled/out.js 
browserify compiled/out.js > compiled/deps.js
