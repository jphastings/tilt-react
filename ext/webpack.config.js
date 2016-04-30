var path = require('path');
var glob = require('glob')
var webpack = require('webpack');

function entryPoints(dir) {
  var entryPoints = {};
  var opts = {
    nosort: true,
    realpath: true,
  };
  glob.sync(path.join(dir, '*.js'), opts).forEach(function (file) {
    var parts = file.match(/\/([^\/]+).js$/);
    if (parts[1] !== null) {
      entryPoints[parts[1]] = file;
    }
  });
  return entryPoints;
}

module.exports = {
  entry: entryPoints('./components'),
  output: {
    path: path.join(__dirname, 'public/js'),
    filename: '[name]_bundle.js'
  },
  module: {
    loaders: [
      {
        test: /.jsx?/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['es2015', 'react'],
        },
      }
    ]
  },
  plugins: [
    // Avoid publishing files when compilation fails
    new webpack.NoErrorsPlugin(),
    // new webpack.optimize.UglifyJsPlugin({minimize: true}),
  ],
  stats: {
    colors: true
  },
  devtool: 'source-map',
};