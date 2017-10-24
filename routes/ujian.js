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
	db('tbujian').select('id','nm_ujian',db.raw('floor(durasi_ujian/3600000) as jam'),db.raw('mod(cast(floor(durasi_ujian/60000) as int),60) as menit'),subquery1,subquery2).limit(limit).offset(offset).where('id',op,id).
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
	console.log(req.header('content-type'));
    var data = req.body;
    var hasil = {};
    console.log(data);
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
                    param: "jam",
                    msg: "",
                    value: data.jam
                };
            }
            if (pesan.menit == undefined) {
                pesan.menit = {
                    param: "menit",
                    msg: "",
                    value: data.menit
                };
            }
            hasil.status = false;
            hasil.error = pesan;
            res.json(hasil);
        } else {
            data.durasi_ujian = (data.jam*3600000)+(data.menit*60000)
			db('tbujian').insert({nm_ujian:data.nm_ujian,durasi_ujian:data.durasi_ujian}).
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
                    param: "jam",
                    msg: "",
                    value: data.jam
                };
            }
            if (pesan.menit == undefined) {
                pesan.menit = {
                    param: "menit",
                    msg: "",
                    value: data.menit
                };
            }
            hasil.status = false;
            hasil.error = pesan;
            res.json(hasil);
        } else {
           var mili = (data.jam*3600000)+(data.menit*60000)
           db('tbujian').where('id','=',id).update({nm_ujian:data.nm_ujian,durasi_ujian:mili}).
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
router.get('/:id/peserta/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    var idPeserta = req.params.idPeserta || 0;
    var op = '';
    if(idPeserta == 0) op = '!=';
    else op = '=';
    var hasil = {};
    if(belumDitambahkan == 0){
		var query = db('tbpeserta').limit(limit).offset(offset).join('tbpeserta_ujian','tbpeserta.id','tbpeserta_ujian.id_peserta').select('tbpeserta.id as id','tbpeserta.nm_peserta as nm_peserta','tbpeserta_ujian.status as status').where('tbpeserta_ujian.id_ujian',id).andWhere('tbpeserta_ujian.id_peserta',op,idPeserta);
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
    if(belumDitambahkan == 0){
		var query = db('tbsoal').limit(limit).offset(offset).join('tbsoal_ujian','tbsoal.id','tbsoal_ujian.id_soal').select('tbsoal.id as id','tbsoal.isi_soal as isi_soal','tbsoal.jawaban as jawaban').where('tbsoal_ujian.id_ujian',id);
	}else{
		var subquery = db('tbsoal_ujian').select('id_soal').where('id_ujian',id);
		var query = db('tbsoal').limit(limit).offset(offset).select().whereNotIn('id',subquery);
	}
    query.then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		if(belumDitambahkan == 0){
			return db('tbsoal').join('tbsoal_ujian','tbsoal.id','tbsoal_ujian.id_soal').count('tbsoal_ujian.id_soal as jumlah').where('tbsoal_ujian.id_ujian',id);
		}else{
			return db('tbsoal').count('id').whereNotIn('id',subquery);
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
router.post('/:id/soal/', (req, res, next) => {
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
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
		var id_soal = 0;
		db('tbsoal').returning('id').insert({
			isi_soal : data.isi_soal,
			jawaban : data.jawaban
			}).
		then(function(id){
			id_soal = id[0];
			var y = data.pilihanGanda.length;
			for(x=0;x<y;x++){
				data.pilihanGanda[x].id_soal = id_soal;
			}
			console.log(data.pilihanGanda);
			return db('tbpilihan_ganda').insert(data.pilihanGanda);
			}).
		then((pesan)=>{
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
router.put('/:id/soal/:id_soal', (req, res, next) => {
	var data = req.body;
	var id = req.params.id;
	var id_soal = req.params.id_soal;
	var hasil = {};
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
		db('tbsoal').update({
		isi_soal : data.isi_soal,
		jawaban : data.jawaban
		}).where('id',id_soal).
		then(function(){
			var y = data.pilihanGanda.length;
			for(x=0;x<y;x++){
				data.pilihanGanda[x].id_soal = id_soal;
			}
			return db('tbpilihan_ganda').where('id_soal',id_soal).del();
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
    var id_peserta = req.params.idPeserta || 0;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var hasil = {};
	db('tbpeserta').limit(limit).offset(offset).select('tbpeserta.nm_peserta','tbhasil_ujian.benar','tbhasil_ujian.salah','tbhasil_ujian.nilai')
	.where('tbhasil_ujian.id_ujian',id).join('tbhasil_ujian','tbhasil_ujian.id_peserta','tbpeserta.id')
    .then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		})
	.then(()=>{
		return db('tbhasil_ujian').count('id_peserta as jumlah').where('id_ujian',id);
		})
	.then((jumlah)=>{
		hasil.row = jumlah[0].jumlah;
		res.json(hasil); 
		})
	.catch((err)=>{
		hasil.status = false;
		hasil.error = err;
		res.json(hasil);
		});
});
router.post('/:id/hasil', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
    var nilai = data.benar*(100/(data.benar+data.salah));
    db('tbhasil_ujian').insert({id_peserta:data.id_peserta,benar:data.benar,salah:data.salah,nilai:nilai})
    .then((id)=>{
		hasil.status = true;
		res.json(hasil);
		})
    .catch((err)=>{
		hasil.status = false;
		hasil.error = err;
		res.json(hasil);
		});
});
module.exports = router;
