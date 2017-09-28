var express = require('express');
var router = express.Router();
var checkData = require('../validator/soal/create_update');
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
	var op = null;
	if(id == 0) op = "!=";
	else op = "=";
	db('tbsoal').select().limit(limit).offset(offset).where('id',op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db('tbsoal').count('id as jumlah');
		}).
	then((jumlah)=>{
		hasil.row = jumlah[0].jumlah;
		return db('tbpilihan_ganda').select('huruf','isi_pilihan').where('id_soal',id);
		}).
	then((pg)=>{
		if(pg.length < 1) res.send(hasil);
		else{
			hasil.data[0].pilihanGanda = pg;
			res.send(hasil);
		}
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
	db('tbsoal').returning('id').insert({
		isi_soal : data.isi_soal,
		jawaban : data.jawaban
		}).
	then(function(id){
		var id_soal = id[0];
		var y = data.pilihanGanda.length;
		for(x=0;x<y;x++){
			data.pilihanGanda[x].id_soal = id_soal;
		}
		return db('tbpilihan_ganda').insert(data.pilihanGanda);
		}).
	then(function(){
		hasil.status =true;
		hasil.error = null;
		res.send(hasil);
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
	var id = req.params.id;
    var hasil = {};
	db('tbsoal').where('id',id).del().
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
		db('tbsoal').update({
		isi_soal : data.isi_soal,
		jawaban : data.jawaban
		}).where('id',id).
		then(function(){
			var y = data.pilihanGanda.length;
			for(x=0;x<y;x++){
				data.pilihanGanda[x].id_soal = id;
			}
			return db('tbpilihan_ganda').where('id_soal',id).del();
			}).
		then(function(){
			return db('tbpilihan_ganda').insert(data.pilihanGanda);
			}).
		then(function(){
			hasil.status =true;
			hasil.error = null;
			res.send(hasil);
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
