var express = require('express');
var router = express.Router();
var checkData = require('../validator/peserta/create_update');
router.get('/',(req, res, next)=>{
	sql = 'call getPeserta(0,0,0);';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.data = r[0];
		hasil.row = r[0].length;
		hasil.error = e;
		res.json(hasil);
		});
	});
router.get('/limit/:lim/offset/:off',(req, res, next)=>{
	var lim = req.params.lim;
	var off = req.params.off;
	sql = 'call getPeserta(0,'+lim+','+off+');';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.data = r[0];
		hasil.row = r[1][0].jumlah;
		hasil.error = e;
		res.json(hasil);
		});
	});
router.get('/:id',(req, res, next)=>{
	var id = req.params.id;
	sql = 'call getPeserta('+id+',0,0);';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.data = r[0];
		hasil.row = r[0].length;
		hasil.error = e;
		res.json(hasil);
		});
	});
router.get('/not/:id',(req, res, next)=>{
	var id = req.params.id;
	sql = 'call getNotPesertaUjian("'+id+'");';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.data = r[0];
		hasil.row = r[0].length;
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
	sql = 'call createPeserta("'+data.nm_peserta+'");';
	koneksi.query(sql, function(e, r, f){
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});
router.delete('/:id',(req,res,next)=>{
	var id = req.params.id;
	var hasil = {};
	sql = 'call deletePeserta('+id+');';
	koneksi.query(sql, (e, r, f)=>{
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
	sql = 'call updatePeserta('+id+',"'+data.nm_peserta+'");';
	koneksi.query(sql, function(e, r, f){
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});

module.exports = router;
