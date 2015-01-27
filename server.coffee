express         = require 'express'
http            = require 'http'
path            = require 'path'
bodyParser      = require 'body-parser'
morgan          = require 'morgan'
_               = require './server/helpers.coffee'

# Create express app
app = express()

# Export environment
global.NODE_ENV = app.settings.env = 'development'

# Configure port
app.set 'port', process.env.PORT || process.argv[2]|| 3200

# Log requests to console
app.use morgan('dev')

# Body parser middleware
app.use bodyParser.json(extended: yes)
app.use bodyParser.urlencoded(extended: yes)

# Where static files are
app.use express.static path.join(__dirname, 'public')

# Setup routing
app.get '/', (req, res) ->
  res.status(200).sendFile __dirname + '/index.html'

# Create server
server = http.createServer app

# Finally start listening requests
server.listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')