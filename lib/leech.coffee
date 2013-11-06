fs = require 'fs'
coffee  = require 'coffee-script'
express = require 'express'
engine = require 'ejs-locals'

class Leech
    module.exports = @

    # Slots
    static_root: "#{process.cwd()}/public/"

    # Init
    constructor: () ->
        console.log "#{@constructor.name} Init"
        @app = express()
        @server = require('http').createServer @app

        # App config
        @app.use express.logger()
        @app.use express.favicon()
        @app.use express.query()
        @app.set 'prefix', process.env.PREFIX or "/"
        @app.set 'root', process.env.ROOT or ""

        # Template config
        @app.engine 'ejs', engine
        @app.set 'view engine', 'ejs'
        @app.set 'views', "#{__dirname}/../views"


        # Static host
        @app.use express.static @static_root

        # Routes
        controllers = "#{__dirname}/controllers/"
        console.log "Loading: #{controllers}/*"
        fs.readdir controllers, (err, files) =>
            return if err
            for file in files
                do (file) =>
                    controller = require "./controllers/#{file}"
                    name = /(.+)\.(.+)$/.exec(file)[1]
                    if name != '_root'
                      @app.use "#{@app.get 'prefix'}#{name}/", controller if controller
                    else
                      @app.use "#{@app.get 'prefix'}", controller if controller

    # Control
    start: (@options = {port: 5000}) =>
        console.warn "#{@constructor.name} Starting on port #{@options.port}"
        @server.listen @options.port

    stop: () =>
        console.warn "#{@constructor.name} Stopping"
        @server?.close()
        @server = undefined