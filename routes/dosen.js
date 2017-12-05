var express = require('express');
var router = express.Router();
var checkData = require('../validator/dosen/create_update');
var pk = 'id_dosen';
var tbl = 'tbdosen';
var json2csv = require('json2csv')

router.get('/cetak/csv',(req,res,next)=>{
    db('tbdosen').select()
    .then(function(rows){
        console.log(rows)
        var data = rows
        var fields = ['id_dosen','nm_dosen','nidn','status']
        json2csv({ data: data, fields: fields }, function(err, csv) {
          if (err) console.log(err);
          console.log(csv);
          res.header('Content-type','text/csv').send(csv)
		})
        }).
	catch(function(err){
		res.json(hasil);
		});
    });
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    if(id == 0){
        query.count = db('tbdosen').select('nidn')
        query.tmp = db('tbdosen').select()
    }else{
        query.count = db('tbdosen').select().where('id_dosen',id)
        query.tmp = db('tbdosen').select().where('id_dosen',id)
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
		hasil.row = rows.length
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});
router.get('/cari/:cari',(req, res, next)=>{
	var cari = req.params.cari;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    query.count = db('tbdosen').select('nidn').where('nidn','like','%'+cari+'%').orWhere(db.raw('lower(nm_dosen)'),'like','%'+cari+'%')
    query.tmp = db('tbdosen').select().where('nidn','like','%'+cari+'%').orWhere(db.raw('lower(nm_dosen)'),'like','%'+cari+'%')
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
		hasil.row = rows.length
		res.json(hasil);
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
		res.json(hasil); 
	}
	else{
		db(tbl).insert(data).
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
			hasil.err = err;
			res.json(hasil);
			});
	}
	});
});

//lihat kuliah yg diampu dosen
router.get('/:id/kuliah',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    query.count = db('lap_kuliah').select().where('nidn',id)
    query.tmp = db('lap_kuliah').select().where('nidn',id)
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
		hasil.row = rows.length
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});
router.get('/:id/ujian',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    query.count = db('lap_ujian').select().where('nidn',id)
    query.tmp = db('lap_ujian').select().where('nidn',id)
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
		hasil.row = rows.length
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});
router.delete('/:id/kuliah/:idKuliah',(req, res, next)=>{
	var idKuliah = req.params.idKuliah
    var id = req.params.id || 0;
    hasil = {}
	db('tbkuliah').where('id_kuliah',idKuliah).del().
    then(rows=>{
        return db('tbkelas_kuliah').where('id_kuliah',idKuliah).del()
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
    
router.post('/:id/kuliah',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
    db(tbl).insert({
        id_kuliah : data.id_kuliah,
        nidn : data.nidn,
        kd_matkul : data.kd_matkul,
        tahun_akademik : data.tahun_akademik,
        }).
    then((rows)=>{
        return db('tbkelas_kuliah').insert(data.kelas)
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
router.delete('/:id/matkul/:id_matkul',(req,res,next)=>{
	var id = req.params.id_matkul;
	var hasil = {}
	db('tbmatkul_dosen').where('id_mdosen',id).del().
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
//lihat ujian yg diampu dosen
router.get('/:id/ujian',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    query.count = db('lap_ujian').select().where('nidn',id)
    query.tmp = db('lap_ujian').select().where('nidn',id)
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
		hasil.row = rows.length
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});

module.exports = router;
