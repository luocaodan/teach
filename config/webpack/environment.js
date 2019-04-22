const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)

// make babel transpile vue-echart
const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = /node_modules\/(?!(vue-echarts|resize-detector)\/).*/
module.exports = environment
