var express = require('express');
var router = express.Router();
var checkData = require('../validator/peserta/create_update');
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = req.query.limit || 0;
	var offset = req.query.offset || 0;
	sql = 'call getPeserta(?,?,?);';
	koneksi.query(sql,[id,limit,offset], (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.data = r[0];
		hasil.row = r[1][0].jumlah;
		hasil.error = e;
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
		if(pesan.nm_peserta == undefined){
			pesan.nm_peserta ={
				param : "nm_peserta",
				msg : "",
				value : data.nm_peserta
			};
		}
		hasil.status = false;
		hasil.error = pesan;
		res.json(hasil); 
	}
	else{
	sql = 'call createPeserta(?);';
	koneksi.query(sql,[data.nm_peserta], function(e, r, f){
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});
router.delete('/:id',(req,res,next)=>{
	var id = " "+req.params.id;
	var hasil = {};
	sql = 'call deletePeserta(?);';
	koneksi.query(sql,[id], (e, r, f)=>{
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.error = e;
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
		if(pesan.nm_peserta == undefined){
			pesan.nm_peserta ={
				param : "nm_peserta",
				msg : "",
				value : data.nm_peserta
			};
		}
		hasil.status = false,
		hasil.error = pesan;
		res.json(hasil);
	}
	else{
	sql = 'call updatePeserta(?,?);';
	koneksi.query(sql,[id,data.nm_peserta], function(e, r, f){
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});

module.exports = router;
