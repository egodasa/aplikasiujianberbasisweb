var express = require('express');
var router = express.Router();
var checkData = require('../validator/ujian/create_update');
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
var checkDataSoal = require('../validator/soal_ujian/create_update');

router.get('/',(req, res, next)=>{
	sql = 'call getUjian("0000000",0,0);';
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
	sql = 'call getUjian("0000000",'+lim+','+off+');';
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
	sql = 'call getUjian("'+id+'",0,0);';
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
router.post('/create',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
	req.checkBody(checkData);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.nm_ujian == undefined){
			pesan.nm_ujian ={
				param : "nm_ujian",
				msg : "",
				value : data.nm_ujian
			};
		}
		if(pesan.jam == undefined){
			pesan.jam ={
				param : "jam",
				msg : "",
				value : data.jam
			};
		}
		if(pesan.menit == undefined){
			pesan.menit ={
				param : "menit",
				msg : "",
				value : data.menit
			};
		}
		hasilstatus = false;
		hasil.error = pesan;
		res.json(hasil); 
	}
	else{
	sql = 'call createUjian("'+data.nm_ujian+'",'+data.jam+','+data.menit+');';
	koneksi.query(sql, function(e, r, f){
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});
router.delete('/delete/:id',(req,res,next)=>{
	var id = req.params.id;
	var hasil = {};
	sql = 'call deleteUjian("'+id+'");';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	});
router.put('/update/:id',(req,res,next)=>{
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
	req.checkBody(checkData);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.nm_ujian == undefined){
			pesan.nm_ujian ={
				param : "nm_ujian",
				msg : "",
				value : data.nm_ujian
			};
		}
		if(pesan.jam == undefined){
			pesan.jam ={
				param : "jam",
				msg : "",
				value : data.jam
			};
		}
		if(pesan.menit == undefined){
			pesan.menit ={
				param : "menit",
				msg : "",
				value : data.menit
			};
		}
		hasil.status = false;
		hasil.error = pesan;
	res.json(hasil);
	}
	else{
	sql = 'call updateUjian("'+id+'","'+data.nm_ujian+'",'+data.jam+','+data.menit+');';
	koneksi.query(sql, function(e, r, f){
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});

//Peserta Ujian
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
router.get('/:id/peserta',(req, res, next)=>{
	var id =req.params.id;
	sql = 'call getPesertaUjian("'+id+'",0);';
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
router.get('/:id/peserta/:id_peserta',(req, res, next)=>{
	var id = req.params.id;
	var id_peserta = req.params.id_peserta;
	sql = 'call getPesertaUjian("'+id+'",'+id_peserta+');';
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
router.post('/:id/peserta/create',(req,res,next)=>{
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
	req.checkBody(checkDataPeserta);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.id_peserta == undefined){
			pesan.id_peserta ={
				param : "id_peserta",
				msg : "",
				value : data.id_peserta
			};
		}
		hasil = {
			status : false,
			error : pesan
			};
	res.json(hasil); 
	}
	else{
	sql = 'call createPesertaUjian("'+id+'",'+data.id_peserta+');';
	console.log(sql);
	koneksi.query(sql, function(e, r, f){
		var hasil = {};
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});
router.post('/:id/peserta/delete',(req,res,next)=>{
	var id = req.params.id;
	var id_peserta_ujian = req.body.id_peserta_ujian;
	console.log(id_peserta_ujian);
	var hasil = {};
	sql = 'call deletePesertaUjian('+id_peserta_ujian+');';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	});
	
//Soal Ujian

router.get('/:id/soal',(req, res, next)=>{
	var id =req.params.id;
	sql = 'call getSoalUjian("'+id+'");';
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
router.get('/:id/soal/:id_soal',(req, res, next)=>{
	var id = req.params.id;
	var id_soal = req.params.id_soal;
	sql = 'call getSoalUjian("'+id+'",'+id_soal+');';
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
router.post('/:id/soal/create',(req,res,next)=>{
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
	req.checkBody(checkDataSoal);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.id_soal == undefined){
			pesan.id_soal ={
				param : "id_soal",
				msg : "",
				value : data.id_soal
			};
		}
		hasil = {
			status : false,
			error : pesan
			};
	res.json(hasil); 
	}
	else{
	sql = 'call createSoalUjian("'+id+'","'+data.id_soal+'");';
	console.log(sql);
	koneksi.query(sql, function(e, r, f){
		var hasil = {};
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	}
	});
});
router.post('/:id/soal/delete',(req,res,next)=>{
	var id = req.params.id;
	var data = req.body;
	var hasil = {};
	sql = 'call deleteSoalUjian('+data.id+');';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
	});
	
//HASIL UJIAN
router.get('/:id/hasil',(req, res, next)=>{
	var id = req.params.id;
	sql = 'call getHasilUjian("'+id+'",0);';
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
router.post('/:id/hasil',(req,res,next)=>{
	var data = req.body;
	var id = req.params.id;
	sql = 'call createHasilUjian("'+id+'",'+data.id_peserta+','+data.benar+','+data.salah+');';
	console.log(sql);
	koneksi.query(sql, function(e, r, f){
		var hasil = {};
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		res.json(hasil);
		});
});
module.exports = router;
