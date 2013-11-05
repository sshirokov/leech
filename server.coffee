Leech = require './lib/leech'

leech = new Leech()

leech.start
    port: process.env.PORT or 5000
