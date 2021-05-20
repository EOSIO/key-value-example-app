const webpack = require('webpack');

module.exports = {
  mode: 'development',
  devtool: 'source-map',
  resolve: {
    extensions: ['.js', '.ts', '.tsx']
  },
  module: {
    rules: [
      {
        test: /\.ts(x?)$/,
        exclude: /node_modules/,
        loader: 'ts-loader'
      },
      {
        enforce: 'pre',
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'source-map-loader'
      },
      {
        test: /\.css?$/,
        use: [
          { loader: 'style-loader' },
          { loader: 'css-loader' }
        ]
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        loader: 'file-loader'
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        loader: 'file-loader'
      },
    ],
  },
  plugins: [
    new webpack.ProvidePlugin({
        Buffer: ["buffer", "Buffer"],
    })
  ],
  resolve: {
      extensions: ['.tsx', '.ts', '.js'],
      fallback: {
          buffer: 'buffer',
          crypto: 'crypto-browserify'
      }
  },
  devServer: {
    overlay: true,
    host: '0.0.0.0',
    sockPort: 443,
    allowedHosts: ['localhost', '.gitpod.io'],
    proxy: {
      '/v1': process.env.NODEOS_URL || 'http://localhost:8888'
    }
  }
}