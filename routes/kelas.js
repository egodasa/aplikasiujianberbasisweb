var express = require('express');
var router = express.Router();
var checkData = require('../validator/kelas/create_update');

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
	db('tbkelas').select().limit(limit).offset(offset).where('id',op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db('tbkelas').count('id as jumlah');
		}).
	then((jumlah)=>{
		hasil.row = jumlah[0].jumlah;
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});
router.post('/',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
	req.checkBody(checkData);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.nm_kelas == undefined){
			pesan.nm_kelas ={
				param : "nm_kelas",
				msg : "",
				value : data.nm_kelas
			};
		}
		hasil.status = false;
		hasil.error = pesan;
		res.json(hasil); 
	}
	else{
		db('tbkelas').insert(data).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.err = err;
			res.json(hasil);
			});
	}
	});
});
router.delete('/:id',(req,res,next)=>{
	var id = " "+req.params.id;
	var hasil = {};
	db('tbkelas').where('id',id).del().
	then(function(){
		hasil.status = true;
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.err = err;
		res.json(hasil);
		});
	});
router.put('/:id',(req,res,next)=>{
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
	req.checkBody(checkData);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.nm_kelas == undefined){
			pesan.nm_kelas ={
				param : "nm_kelas",
				msg : "",
				value : data.nm_kelas
			};
		}
		hasil.status = false,
		hasil.error = pesan;
		res.json(hasil);
	}
	else{
		db('tbkelas').where('id','=',id).update(data).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.err = err;
			res.json(hasil);
			});
	}
	});
});

module.exports = router;
