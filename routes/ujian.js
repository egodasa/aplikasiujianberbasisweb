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
    var id_mahasiswa = req.params.idPeserta || 0;
    var limit = 1*req.query.limit || null;
    var offset = 1*req.query.offset || null;
    var hasil = {};
	db('tbmahasiswa').limit(limit).offset(offset).select('tbmahasiswa.nm_peserta','tbhasil_ujian.benar','tbhasil_ujian.salah','tbhasil_ujian.nilai')
	.where('tbhasil_ujian.id_ujian',id).join('tbhasil_ujian','tbhasil_ujian.id_mahasiswa','tbmahasiswa.id')
    .then((rows)=>{
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		})
	.then(()=>{
		return db('tbhasil_ujian').count('id_mahasiswa as jumlah').where('id_ujian',id);
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
    db('tbhasil_ujian').insert({id_mahasiswa:data.id_mahasiswa,benar:data.benar,salah:data.salah,nilai:nilai})
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
