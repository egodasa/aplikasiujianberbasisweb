var express = require('express');
var router = express.Router();
var checkData = require('../validator/ujian/create_update');
//var checkDataPeserta = require('../validator/peserta_ujian/create_update');
router.get('/:id/peserta',(req, res, next)=>{
	var id =req.params.id;
	sql = 'call getPesertaUjian("'+id+'",0);';
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
router.get('/:id/peserta/:id_peserta',(req, res, next)=>{
	var id = req.params.id;
	var id_peserta = req.params.id_peserta;
	sql = 'call getPesertaUjian("'+id+'",'+id_peserta+');';
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
router.post('/:id/peserta/create',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
	/*
	req.check(checkDataPeserta);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.id_ujian == undefined){
			pesan.id_ujian ={
				param : "id_ujian",
				msg : "",
				value : data.id_ujian
			};
		}
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
	res.status(400).json(hasil); 
	}
	else{*/
	sql = 'call createPesertaUjian("'+id+'",'+data.id_peserta+');';
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
	//}
	//});
});
router.post('/:id/peserta/delete',(req,res,next)=>{
	var id = req.params.id;
	var id_peserta_ujian = req.body.id_peserta_ujian;
	var hasil = {};
	sql = 'call deletePesertaUjian('+id_peserta_ujian+');';
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

module.exports = router;
