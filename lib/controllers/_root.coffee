express = require 'express'
fs = require 'fs'
fstream = require 'fstream'
tar = require 'tar'

#



module.exports = app = express()

fail = (req, res, err) ->
  res.status 500
  res.json error: "#{err}"

app.get '/tar/', (req, res) =>
  path = "#{app.get 'root'}/#{req.query.path}"
    .replace(/\.\./g, '')
    .replace(/\/\//g, '/')
  fs.lstat path, (err, stats) ->
    if err or not stats.isDirectory()
      res.status 400
      res.json error: err or "Not A Directory"
    else
      name = path.split('/')
      name = name[name.length - 1]
      res.attachment "#{name}.tar"
      fstream.Reader({ type: "Directory" , path: path })
        .pipe(tar.Pack({}))
          .on("error", ->
            res.status 500
            res.json error: 'Unable to create tarball'
          )
          .pipe(res)

app.get '/fetch/', (req, res) =>
  path = "#{app.get 'root'}/#{req.query.path}"
    .replace(/\.\./g, '')
    .replace(/\/\//g, '/')
  fs.lstat path, (err, stats) ->
    if err or not stats.isFile()
      res.status 400
      res.json error: err or "Not A File"
    else
      res.download path, (err) ->
        if err
          res.json error: err or "Not A File"

app.get '/?', (req, res) =>
  dir = path = req.query.path or ""
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
        res.render 'browse', files: listing, base: dir

    for file in files
      do (file) ->
        fs.lstat "#{path}/#{file}", (err, stats) ->
          if err
            failed = true
            return fail(req, res, err)
          unless failed
            finish(file, stats)
