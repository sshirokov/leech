express = require('express')
fs = require('fs')

module.exports = app = express()

fail = (req, res, err) ->
  res.status 500
  res.json error: "#{err}"

app.get '/?', (req, res) =>
  path = req.query.path or ""
  path = "#{app.get 'root'}/#{path}".replace /\.\./g, ''
  listing = []

  fs.readdir path, (err, files) ->
    return fail(req, res, err) if err
    left = files.length
    failed = false

    finish = (file, stats) ->
      left -= 1
      listing.push
        name: file
        path: "#{path}#{file}"
        dir: stats.isDirectory()
      if left == 0
        res.render 'browse', files: listing

    for file in files
      do (file) ->
        fs.lstat "#{path}/#{file}", (err, stats) ->
          if err
            failed = true
            return fail(req, res, err)
          unless failed
            finish(file, stats)
