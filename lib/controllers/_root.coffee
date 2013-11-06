express = require('express')
fs = require('fs')

module.exports = app = express()

fail = (req, res, err) ->
  res.status 500
  res.json error: "#{err}"

app.get '/?', (req, res) =>
  path = req.query.path or ""
  path = "#{app.get 'root'}/#{path}".replace /\.\./g, ''
  fs.readdir path, (err, files) ->
    return fail(req, res, err) if err
    res.render 'browse', files: files
