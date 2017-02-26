
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , url = require('url')
    , bodyParser = require('body-parser')
  , proxy = require('proxy-middleware');

var app = module.exports = express.createServer();

app.use('/api/hotels', proxy(url.parse('https://m.travelrepublic.co.uk/api2/hotels/static/gethotelsbydestination')));
app.use('/api/destinations', proxy(url.parse('https://m.travelrepublic.co.uk/api2/destination/v2/search')));

// Configuration
app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
    app.use(bodyParser.json());
  //app.use(express.bodyParser());
    app.use(bodyParser.urlencoded({ extended: false }));
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);
app.get('/api/hotel', function(req, res){
  var fs = require('fs');
  var _ = require('lodash');
  var request = require('request');
  var estabid = parseInt(req.query.estabId);
  var hotel = null;
  if(estabid) {
    console.log(estabid);

    request({
      url: 'https://m.travelrepublic.co.uk/api2/hotels/static/gethotelsbydestination',
      method: "POST",
      headers: {"content-type": "application/json"},
      json: {
        CultureCode:"en-gb",DomainId:1,TradingGroupId:1,CurrencyCode:"GBP",
        Destination:{CountryId:3522,ProvinceId:54875,LocationId:0,PlaceId:0,EstablishmentId:estabid,PolygonId:0,PageStrand:1}
      }
    }, function (error, resp, body) {
      console.log(error);
      res.setHeader('Content-Type', 'application/json');
      hotel = _.find(resp.body.Establishments, function (h) {
        return h.EstablishmentId === estabid;
      });
      console.log(hotel);
      res.send(hotel);
    });
  }
});

app.listen(3001, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
