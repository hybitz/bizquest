const path    = require("path")
const webpack = require("webpack")
const { VueLoaderPlugin } = require('vue-loader')

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

module.exports = {
  mode: mode,
  optimization: {
    moduleIds: 'deterministic'
  },
  entry: {
    application: "./app/javascript/application.js"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    chunkFormat: "module",
    path: path.resolve(__dirname, "app/assets/builds"),
  },
  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif|svg)$/i,
        type: "asset/resource",
        generator: {
          filename: "images/[name]-[hash].digested[ext]",
        },
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.css$/,
        use: [
          'vue-style-loader',
          'css-loader'
        ]
      }
    ]
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new VueLoaderPlugin()
  ],
  resolve: {
    extensions: ['.js', '.vue'],
    preferRelative: true
  }
}
