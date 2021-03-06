const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = (env, options) => ({
  optimization: {
    minimizer: [new TerserPlugin({}), new OptimizeCSSAssetsPlugin({})],
  },
  entry: {
    app: glob.sync("./vendor/**/*.js").concat(["./js/app.js"]),
    tally: glob.sync("./vendor/**/*.js").concat(["./js/tally/index.js"]),
    ballot: glob.sync("./vendor/**/*.js").concat(["./js/ballot/index.js"]),
    vote: glob.sync("./vendor/**/*.js").concat(["./js/vote/index.js"]),
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "../priv/static/js"),
  },
  devtool: "source-map",
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
        },
      },
      {
        test: /\.scss$/,
        use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
      },
      {
        test: /\.(?:svg|eot|ttf|woff|woff2)$/,
        use: [
          {
            loader: "file-loader",
            options: {
              outputPath: "../css",
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: "../css/app.css" }),
    new CopyWebpackPlugin([{ from: "static/", to: "../" }]),
  ],
});
