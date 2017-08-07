var express = require('express');
var router = express.Router();
var checkData = require('../validator/peserta/create_update');
router.get('/',(req, res, next)=>{
	sql = 'call getPeserta(0);';
	koneksi.query(sql, (e, r, f)=>{
		if(!e){
			var hasil = {
				status : true,
				data : r[0],
				error : null
				};
			}
		else {
			var hasil = {
				status : false,
				data : r[0],
				error : e
				};
			
			}
		res.json(hasil);
		});
	});
router.get('/:id',(req, res, next)=>{
	var id = req.params.id;
	sql = 'call getPeserta('+id+');';
	koneksi.query(sql, (e, r, f)=>{
		if(!e){
				if(r[0].length == 0) {
					var hasil = {
						status : false,
						data : r[0],
						error : "Data tidak ditemukan!"
						};
					
				}
				else {
					var hasil = {
						status : true,
						data : r[0],
						error : null
					};
				}
			}
		else {
			var hasil = {
				status : false,
				data : r[0],
				error : e
				};
				
			}
		res.json(hasil);
		});
	});
router.get('/not/:id',(req, res, next)=>{
	var id = req.params.id;
	sql = 'call getNotPesertaUjian("'+id+'");';
	koneksi.query(sql, (e, r, f)=>{
		if(!e){
				if(r[0].length == 0) {
					var hasil = {
						status : false,
						data : r[0],
						error : "Data tidak ditemukan!"
						};
					
				}
				else {
					var hasil = {
						status : true,
						data : r[0],
						error : null
					};
				}
			}
		else {
			var hasil = {
				status : false,
				data : r[0],
				error : e
				};
				
			}
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
		if(pesan.nm_peserta == undefined){
			pesan.nm_peserta ={
				param : "nm_peserta",
				msg : "",
				value : data.nm_peserta
			};
		}
		hasil = {
			status : false,
			error : pesan
			};
	res.json(hasil); 
	}
	else{
	sql = 'call createPeserta("'+data.nm_peserta+'");';
	koneksi.query(sql, function(e, r, f){
		if(!e){
			hasil = {
					status : true,
					error : null
				};
			}
		else {
			hasil = {
					status : false,
					error : e
				};
			
			}
		res.json(hasil);
		});
	}
	});
});
router.delete('/delete/:id',(req,res,next)=>{
	var id = req.params.id;
	var hasil = {};
	sql = 'call deletePeserta('+id+');';
	koneksi.query(sql, (e, r, f)=>{
		if(!e){
				if(r.affectedRows != 0){
					hasil = {
						status : true,
						error : null
						};
				}
				else {
					hasil = {
						status : false,
						error : "Data tidak ditemukan"
						};
					
					}
			}
		else {
			hasil = {
				status : false,
				error : e
				};
			
			}
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
		if(pesan.nm_peserta == undefined){
			pesan.nm_peserta ={
				param : "nm_peserta",
				msg : "",
				value : data.nm_peserta
			};
		}
		hasil = {
			status : false,
			error : pesan
			}; 
	res.json(hasil);
	}
	else{
	sql = 'call updatePeserta('+id+',"'+data.nm_peserta+'");';
	koneksi.query(sql, function(e, r, f){
		if(!e){
			if(r.affectedRows != 0){
					hasil = {
						status : true,
						error : null
						};
				}
				else {
					hasil = {
						status : false,
						error : "ID Data tidak ditemukan"
						};
					
				}
			}
		else {
			hasil = {
					status : false,
					error : e
				};
			
			}
		res.json(hasil);
		});
	}
	});
});

module.exports = router;
