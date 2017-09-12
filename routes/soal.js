var express = require('express');
var router = express.Router();
var checkData = require('../validator/soal/create_update');
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || "0000000";
	var limit = req.query.limit || 0;
	var offset = req.query.offset || 0;
	sql = 'call getSoal(?,?,?);';
	if(id != "0000000") sql = sql + ' select * from tbpilihan_ganda where id_soal="'+id+'"';
	koneksi.query(sql,[id,limit,offset], (e, r, f)=>{
		var hasil = {};
		if(!e) hasil.status = true;	
		else hasil.status = false;
		hasil.data = r[0];
		if(id != "0000000") r[0][0].pilihanGanda = r[3];
		hasil.row = r[1][0].jumlah;
		hasil.error = e;
		res.json(hasil);
		});
	});
router.post('/',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
	console.log(data);
	req.checkBody(checkData);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.isi_soal == undefined){
			pesan.isi_soal ={
				param : "isi_soal",
				msg : "",
				value : data.isi_soal
			};
		}
		if(pesan.jawaban == undefined){
			pesan.jawaban ={
				param : "jawaban",
				msg : "",
				value : data.jawaban
			};
		}
		hasil.status = false;
		hasil.error = pesan;
	console.log(hasil);
	res.json(hasil); 
	}
	else{
	var sql1 = '';
	var pg = data.pilihanGanda;
	for(var x=0;x<pg.length;x++){
		if(x == 0) sql1 = '(@id_pg,"'+pg[x].huruf+'","'+pg[x].isi_pilihan+'")';
		else sql1+= ',(@id_pg,"'+pg[x].huruf+'","'+pg[x].isi_pilihan+'")';
	}
	sql = 'set @id_pg=genIdSoal(); call createSoal(@id_pg,?,?); insert into tbpilihan_ganda (id_soal,huruf,isi_pilihan) values '+sql1+';';
	koneksi.query(sql,[data.isi_soal,data.jawaban], function(e, r, f){
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		console.log(hasil);
		res.json(hasil);
		});
	}
	});
});
router.delete('/:id',(req,res,next)=>{
	var id = req.params.id;
	sql = 'call deleteSoal("'+id+'");';
	koneksi.query(sql, (e, r, f)=>{
		var hasil = {};
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
		if(pesan.isi_soal == undefined){
			pesan.isi_soal ={
				param : "isi_soal",
				msg : "",
				value : data.isi_soal
			};
		}
		if(pesan.jawaban == undefined){
			pesan.jawaban ={
				param : "jawaban",
				msg : "",
				value : data.jawaban
			};
		}
		hasil.status = false;
		hasil.error = pesan;
	res.json(hasil);
	}
	else{
	var sql1 = '';
	var pg = data.pilihanGanda;
	for(var x=0;x<pg.length;x++){
		if(x == 0) sql1 = '("'+id+'","'+pg[x].huruf+'","'+pg[x].isi_pilihan+'")';
		else sql1+= ',("'+id+'","'+pg[x].huruf+'","'+pg[x].isi_pilihan+'")';
	}
	sql = 'call updateSoal("'+id+'","'+data.isi_soal+'","'+data.jawaban+'"); insert into tbpilihan_ganda (id_soal,huruf,isi_pilihan) values '+sql1+';';
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
