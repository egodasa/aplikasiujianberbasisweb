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
	db('lap_soal').select().limit(limit).offset(offset).where('id_soal',op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
        res.send(hasil);
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
    console.log(data)
	req.checkBody(checkData);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false;
		hasil.error = pesan;
        console.log(hasil.error);
        res.json(hasil); 
	}
	else{
	db('tbsoal').insert({
        isi_soal:data.isi_soal,
        jawaban:data.jawaban,
        pilihanGanda:JSON.stringify(data.pilihanGanda),
        id_tsoal:data.id_tsoal,
        bobot:data.bobot
        }).then(()=>{
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
	db('tbsoal').where('id_soal',id).del().
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
		hasil.status = false;
		hasil.error = pesan;
	res.json(hasil);
	}
	else{
		db('tbsoal').update({
        isi_soal:data.isi_soal,
        jawaban:data.jawaban,
        pilihanGanda:JSON.stringify(data.pilihanGanda),
        id_tsoal:data.id_tsoal,
        bobot:data.bobot
        }).where('id_soal',id).
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
