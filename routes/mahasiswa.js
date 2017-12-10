var express = require('express');
var router = express.Router();
var checkData = require('../validator/mahasiswa/create_update');
var pk = 'id_mahasiswa';
var tbl = 'tbmahasiswa';
const _ = require('lodash')
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    console.log(req.query)
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    if(id == 0){
        query.count = db('tbmahasiswa').select('id_mahasiswa')
        //query.tmp = db('tbmahasiswa').select().where(req.query)
        query.tmp = db('tbmahasiswa').select()
    }else{
        query.count = db('tbmahasiswa').select().where('id_mahasiswa',id)
        query.tmp = db('tbmahasiswa').select().where('id_mahasiswa',id)
    }
    if(limit == null && offset == null) {
        query.show = query.tmp
    }
    else {
        query.show = query.tmp.limit(limit).offset(offset)
    }
	query.show.then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return query.count
		}).
	then((rows)=>{
		 let code
		hasil.row = rows.length
        if(rows.length == 0) code = 204
        else code = 200
		res.status(code).json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.status(503).json(hasil);
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
		res.status(422).json(hasil); 
	}
	else{
		db(tbl).insert(data).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.error = err;
			res.json(hasil);
			});
	}
	});
});
router.delete('/:id',(req,res,next)=>{
	var id = " "+req.params.id;
	var hasil = {};
	db(tbl).where(pk,id).del().
	then(function(){
		hasil.status = true;
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.status(503).json(hasil);
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
		hasil.status = false,
		hasil.error = pesan;
		res.json(hasil);
	}
	else{
		db(tbl).where(pk,'=',id).update(data).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.error = err;
			res.json(hasil);
			});
	}
	});
});

//daftar ujian yang diikuti peserta
router.get('/:id/ujian',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    console.log(req.query)
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    query.count = db('lap_peserta_ujian').select('id_ujian').where('nobp',id)
    query.tmp = db('lap_peserta_ujian').select(db.raw('id_ujian,cast(hari as varchar),mulai,selesai,deskripsi,status_ujian,nm_status_ujian,id_jsoal,nm_jsoal,id_jujian,nm_jujian,kd_matkul,nm_matkul,nidn,nm_dosen,id_kuliah,nobp,nm_mahasiswa,id_kelas,nm_kelas,nm_ujian')).whereRaw("hari = cast(now() as date) and status_ujian=1 and cast(now() as time) between mulai - interval '15 minute' and selesai and nobp=? and nobp in (select nobp from getHasilUjian(id_ujian) where nobp=? and status_ujian_peserta = 3);",[id,id])
    if(limit == null && offset == null) {
        query.show = query.tmp
    }
    else {
        query.show = query.tmp.limit(limit).offset(offset)
    }
	query.show.then(function(rows){
        console.log(rows)
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return query.count
		}).
	then((rows)=>{
		 let code
		hasil.row = rows.length
        if(rows.length == 0) code = 204
        else code = 200
		res.status(code).json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});
module.exports = router;
