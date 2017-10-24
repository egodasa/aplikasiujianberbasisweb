var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var validator = require('express-validator');
var fileUpload = require('express-fileupload');
var Promise = require('promise');
var url = require('url');
var knexLogger = require('knex-logger');
mysql = require('mysql');
var urlDb = url.parse(process.env.DATABASE_URL_MYSQL);
var auth = urlDb.auth.split(":");
var mysqlSetting = {
		host : urlDb.hostname,
		user : auth[0],
		password : auth[1] || "",
		database : urlDb.path.substr(1),
		multipleStatements : true
		};
//koneksi = mysql.createPool(mysqlSetting);
db = require('knex')({
  client: 'pg',
  connection: process.env.DATABASE_URL_PSQL
});
var app = express();
{}
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(knexLogger(db));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(fileUpload());
app.use(function(req,res,next){
	res.set({'Access-Control-Allow-Origin' : '*'});
	next()
	});
app.use(validator({
	customValidators : require('./validator/custom_validator')
}));

//ROUTES
app.use('/api/soal', require('./routes/soal'));
app.use('/api/ujian', require('./routes/ujian'));
app.use('/api/peserta', require('./routes/peserta'));

/*
app.get('/test',(req,res,next)=>{
	console.log(mysqlSetting);
	res.send({
		host : urlDb.hostname,
		user : auth[0],
		password : auth[1],
		database : urlDb.path.substr(1)
		});
	});
	*/
//EOF ROUTES

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
