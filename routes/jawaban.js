var express = require('express');
var router = express.Router();
var tbl = 'tbjawaban'
var pk = 'id_jawaban'
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
	var op = null;
	if(id == 0) op = "!=";
	else op = "=";
	db(tbl).select().limit(limit).offset(offset).where(pk,op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
        res.send(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});
router.post('/',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
	db(tbl).insert(data).then(()=>{
		hasil.status =true;
		hasil.error = null;
		res.send(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.status(503).json(hasil);
		});
    });
});
router.delete('/:id',(req,res,next)=>{
	var id = req.params.id;
    var hasil = {};
	db(tbl).where(pk,id).del().
	then(function(){
		hasil.status = true;
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});
});

module.exports = router;
