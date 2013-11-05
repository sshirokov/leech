express = require('express')

module.exports = app = express()

app.get '/?', (req, res) =>
  res.json hello: 'world'
