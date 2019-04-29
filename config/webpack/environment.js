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

// add monacoEditor webpack plugin
const MonacoEditorPlugin = require('monaco-editor-webpack-plugin')
environment.plugins.prepend('MonacoEditorPlugin', new MonacoEditorPlugin({
  // 不要删除 typescript
  // https://github.com/Microsoft/monaco-editor-webpack-plugin/issues/27
  languages: ['javascript', 'typescript']
}))
module.exports = environment
