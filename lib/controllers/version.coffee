fs = require('fs')
express = require('express')

module.exports = app = express()

app.get '/?', (req, res) =>
  fs.readFile './package.json', (err, data) =>
    if err
      res.status 500
      res.json version: 'unknown', error: error
    else
      try
        pack = JSON.parse(data)
        res.json version: pack.version
      catch e
        res.status 500
        res.json version: 'unknown', error: e
