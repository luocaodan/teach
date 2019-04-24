const {environment} = require('@rails/webpacker')
const {VueLoaderPlugin} = require('vue-loader')
const vue = require('./loaders/vue')

// make babel transpile vue-echart
const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = []
babelLoader.exclude.push(/node_modules\/(?!(vue-echarts)\/).*/)
babelLoader.exclude.push(/node_modules\/(?!(resize-detector)\/).*/)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
