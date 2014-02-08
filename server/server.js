var express = require('express');
var path = require('path');
var app = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);

app.get('*', function(req, res, next) {
    res.setHeader("X-UA-Compatible", "IE=edge");
    next();
});

app.use(express.static(path.resolve(__dirname, '../dist')));


app.post('/signup', function(req, res){
	console.log(req);
	console.log(req.body);
  	res.end();
});



app.listen(5050);

console.log("Server listening in on port 5050");

