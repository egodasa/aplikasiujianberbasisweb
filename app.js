var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var validator = require('express-validator');
var fileUpload = require('express-fileupload');
var Promise = require('promise');

mysql = require('mysql');

koneksi = mysql.createPool({
		host : 'sql12.freemysqlhosting.net',
		user : 'sql12189662',
		password : '2mnJVriMNR',
		database : 'sql12189662',
		multipleStatements : true
		});
/*
koneksi = mysql.createPool({
		host : 'localhost',
		user : 'root',
		password : 'qwe123*iop',
		database : 'dbujian',
		multipleStatements : true
		});
		*/
var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
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
