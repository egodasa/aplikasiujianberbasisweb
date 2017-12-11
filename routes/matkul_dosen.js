var express = require('express');
var router = express.Router();
var pk = 'id_kuliah';
var tbl = 'tbkuliah';
router.get('/:id?',(req, res, next)=>{
	var id_tmp = req.params.id;
    var id = null;
    id_tmp == undefined ? id = 0 : id = id_tmp;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
	var op = null;
	if(id == 0) op = "!=";
	else op = "=";
	db('lap_kuliah').select().limit(limit).offset(offset).where(pk,op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db(tbl).count(pk+' as jumlah');
		}).
	then((jumlah)=>{
		let code
		hasil.row = jumlah[0].jumlah;
        if(hasil.row == 0) code = 204
        else code = 200
		res.status(code).json(hasil); 
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
    db(tbl).insert(data).
    then(function(){
        hasil.status = true;
        res.json(hasil);
        }).
    catch(function(err){
        hasil.status = false;
        hasil.error = err;
        res.json(hasil);
        });
	}); 
router.delete('/:id',(req,res,next)=>{
	var id = " "+req.params.id;
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

module.exports = router;
