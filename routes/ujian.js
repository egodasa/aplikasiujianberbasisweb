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
	db('lap_ujian').select().where('id_ujian',op,id).
    then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db('lap_ujian').count('id_ujian as jumlah');
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
    data.durasi_ujian = (data.jam*3600000)+(data.menit*60000)
    db('tbujian').insert({
        id_kuliah : data.id_kuliah,
        id_tsoal : data.id_tsoal,
        id_jujian : data.id_jujian,
        durasi_ujian : data.durasi_ujian,
        deskripsi : data.deskripsi
        }).
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
router.delete('/:id', (req, res, next) => {
    var id = req.params.id;
    var hasil = {};
	db('tbujian').where('id_ujian',id).del().
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
    var mili = (data.jam*3600000)+(data.menit*60000)
   db('tbujian').where('id_ujian','=',id).update({nm_ujian:data.nm_ujian,durasi_ujian:mili}).
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

//Soal Ujian

router.get('/:id/soal', (req, res, next) => {
    var id = req.params.id;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    var hasil = {};
    db('lap_soal_ujian').select().where('id_ujian',id).then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
        return db('lap_soal_ujian').select().where('id_ujian',id).count('* as jumlah')
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
    console.log(data)
    var hasil = {}
	var id_ujian = 0+req.params.id*1
	req.checkBody(checkDataSoal);
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
        }).returning('id_soal').then((id)=>{
		return db('tbsoal_ujian').insert({id_ujian:id_ujian,id_soal:1*id+0})
		}).
    then(()=>{
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
router.put('/:id/soal/:id_soal', (req, res, next) => {
	var data = req.body;
	var id_soal = req.params.id_soal;
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
        }).where('id_soal',id_soal).
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

//JAWABAN PESERTA ESSSAI
router.get('/:id/jawaban/:idPeserta',(req, res, next)=>{
	var id = req.params.id || 0;
	var idPeserta = req.params.idPeserta || 0;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
	var op = null;
	if(id == 0) op = "!=";
	else op = "=";
	db('tbjawaban').select().limit(limit).offset(offset).where({'id_ujian' : id,'id_peserta':idPeserta}).
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
router.post('/:id/jawaban',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
	db('tbjawaban').insert(data).then(()=>{
		hasil.status =true;
		hasil.error = null;
		res.send(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.err = err;
		res.json(hasil);
		});
    });
router.delete('/:id',(req,res,next)=>{
	var id = req.params.id;
    var hasil = {};
	db('tbjawaban').where('id_jawaban',id).del().
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

//HASIL UJIAN
router.get('/:id/hasil/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var id_mahasiswa = req.params.idPeserta || 0;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var hasil = {};
	var query = db('lap_hasil_ujian').select().where('id_ujian',id) 
    query.limit(limit).offset(offset).then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		})
	.then(()=>{
		return query.count('* as jumlah');
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
module.exports = router;
