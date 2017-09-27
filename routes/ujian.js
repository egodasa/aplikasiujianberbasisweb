var express = require('express');
var router = express.Router();
var checkData = require('../validator/ujian/create_update');
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
var checkDataSoal = require('../validator/soal/create_update');

router.get('/:id?', (req, res, next) => {
	var id = req.params.id || 0;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
	var op = null;
	if(id == 0) op = "!=";
	else op = "=";
	var field_ujian = db.raw('??',['tbujian.id']);
	var subquery1 = db('tbpeserta_ujian').count('tbpeserta_ujian.id_peserta').where('tbpeserta_ujian.id_ujian',field_ujian).as('banyak_peserta');
	var subquery2 = db('tbsoal_ujian').count('tbsoal_ujian.id_soal').where('tbsoal_ujian.id_ujian',field_ujian).as('banyak_soal');
	db('tbujian').select('*',subquery1,subquery2).limit(limit).offset(offset).where('id',op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db('tbujian').count('id as jumlah');
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
router.post('/', (req, res, next) => {
    var data = req.body;
    var hasil = {};
    req.checkBody(checkData);
    req.getValidationResult().then(function(result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
			if (pesan.nm_ujian == undefined) {
                pesan.nm_ujian = {
                    param: "nm_ujian",
                    msg: "",
                    value: data.nm_ujian
                };
            }
            if (pesan.jam == undefined) {
                pesan.jam = {
                    param: "durasi_ujian",
                    msg: "",
                    value: data.durasi_ujian
                };
            }
            hasil.status = false;
            hasil.error = pesan;
            res.json(hasil);
        } else {
			db('tbujian').insert(data).
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
router.delete('/:id', (req, res, next) => {
    var id = req.params.id;
    var hasil = {};
	db('tbujian').where('id',id).del().
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
router.put('/:id', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
    req.checkBody(checkData);
    req.getValidationResult().then(function(result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            if (pesan.nm_ujian == undefined) {
                pesan.nm_ujian = {
                    param: "nm_ujian",
                    msg: "",
                    value: data.nm_ujian
                };
            }
            if (pesan.jam == undefined) {
                pesan.jam = {
                    param: "durasi_ujian",
                    msg: "",
                    value: data.durasi_ujian
                };
            }
            hasil.status = false;
            hasil.error = pesan;
            res.json(hasil);
        } else {
           db('tbujian').where('id','=',id).update(data).
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

//Peserta Ujian
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
router.get('/:id/peserta/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    var hasil = {};
    if(belumDitambahkan == 0){
		var query = db('tbpeserta').limit(limit).offset(offset).join('tbpeserta_ujian','tbpeserta.id','tbpeserta_ujian.id_peserta').select('tbpeserta.id as id','tbpeserta.nm_peserta as nm_peserta').where('tbpeserta_ujian.id_ujian',id);
	}else{
		var subquery = db('tbpeserta_ujian').select('id_peserta').where('id_ujian',id);
		var query = db('tbpeserta').limit(limit).offset(offset).select().whereNotIn('id',subquery);
	}
    query.then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		if(belumDitambahkan == 0){
			return db('tbpeserta').join('tbpeserta_ujian','tbpeserta.id','tbpeserta_ujian.id_peserta').count('tbpeserta_ujian.id_peserta as jumlah').where('tbpeserta_ujian.id_ujian',id);
		}else{
			return db('tbpeserta').count('id').whereNotIn('id',subquery);
		}
		})
	.then((jumlah)=>{
		hasil.row = jumlah[0].jumlah;
		res.json(hasil);
		})
	.catch((err)=>{
		hasil.status = false;
		hasil.error = err;
		res.json(err);
		});
    });
router.post('/:id/peserta/', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
	console.log(data);
	db('tbpeserta_ujian').insert(data)
	.then(()=>{
		hasil.status = true;
		res.send(hasil);
		})
	.catch((err)=>{
		hasil.status = true;
		hasil.error = err;
		res.send(hasil);
		});
});
router.delete('/:id/peserta/:id_pu', (req, res, next) => {
    var id_ujian = req.params.id;
    var id_peserta = req.params.id_pu;
    var hasil = {};
    db('tbpeserta_ujian').where({id_peserta:id_peserta,id_ujian:id_ujian}).del()
    .then(()=>{
		hasil.status = true;
		res.json(hasil);
		})
	.catch((err)=>{
		hasil.status = false;
		hasil.error = err;
		res.json(hasil);
		});
});

//Soal Ujian

router.get('/:id/soal', (req, res, next) => {
    var id = req.params.id;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    var hasil = {};
    db('tbsoal').limit(limit).offset(offset).join('tbsoal_ujian','tbsoal.id','tbsoal_ujian.id_soal').
    select('tbsoal.id as id','tbsoal.isi_soal as isi_soal').where('tbsoal_ujian.id_ujian',id)
    .then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db('tbsoal').join('tbsoal_ujian','tbsoal.id','tbsoal_ujian.id_soal').count('tbsoal_ujian.id_soal as jumlah').where('tbsoal_ujian.id_ujian',id);
		})
	.then((jumlah)=>{
		hasil.row = jumlah[0].jumlah;
		res.json(hasil);
		})
	.catch((err)=>{
		hasil.status = false;
		hasil.error = err;
		res.json(err);
		});
});
router.post('/:id/soal/', (req, res, next) => {
	var data = req.body;
	var hasil = {};
	console.log(data);
	req.checkBody(checkDataSoal);
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
		var id_soal = id;
		var y = data.pilihanGanda.length;
		for(x=0;x<y;x++){
			data.pilihanGanda[x].id_soal = id;
		}
		return db('tbpilihan_ganda').insert(data.pilihanGanda);
		}).
	then(()=>{
		return db('tbsoal_ujian').insert({id_ujian : id,id_soal:id_soal});
		}).
	then(function(){
		hasil.status =true;
		hasil.error = null;
		res.send(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.json(hasil);
		});
	}
	});
});
router.delete('/:id/soal/:idSoal', (req, res, next) => {
    var id = req.params.id;
    var id_soal = req.params.idSoal;
    var data = req.body;
    var hasil = {};
    db('tbsoal_ujian').where({id_soal : id_soal,id_ujian:id}).del()
    .then(()=>{
		hasil.status = true;
		res.json(hasil);
		})
	.catch((err)=>{
		hasil.status = false;
		hasil.error = err;
		res.json(hasil);
		});
});

//HASIL UJIAN
router.get('/:id/hasil/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var id = req.params.idPeserta || 0;
    var limit = req.query.limit || 0;
    var offset = req.query.offset || 0;
    sql = 'call getHasilUjian(?,?,?,?);';
    koneksi.query(sql,[id,idPeserta,limit,offset], (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.data = r[0];
        hasil.row = r[1][0].jumlah;
        hasil.error = e;
        res.json(hasil);
    });
});
router.post('/:id/hasil', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    sql = 'call createHasilUjian(?,?,?,?);';
    console.log(sql);
    koneksi.query(sql,[id,data.id_peserta,data.benar,data.salah], function(e, r, f) {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.error = e;
        res.json(hasil);
    });
});
module.exports = router;
