var express = require('express');
var router = express.Router();
var validator = require('../validator/validator');
var pk = 'id_matkul';
var tbl = 'tbmatkul';
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
        query.count = db('tbmatkul').select('id_matkul')
        //query.tmp = db('tbmatkul').select().where(req.query)
        query.tmp = db('tbmatkul').select()
    }else{
        query.count = db('tbmatkul').select().where('id_matkul',id)
        query.tmp = db('tbmatkul').select().where('id_matkul',id)
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
    query.count = db('tbmatkul').select('kd_matkul').where('kd_matkul','like','%'+cari+'%').orWhere(db.raw('lower(nm_matkul)'),'like','%'+cari+'%')
    query.tmp = db('tbmatkul').select().where('kd_matkul','like','%'+cari+'%').orWhere(db.raw('lower(nm_matkul)'),'like','%'+cari+'%')
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
	req.checkBody(validator.matkul);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false;
		hasil.error = pesan;
		res.status(422).json(hasil); 
	}
	else{
		db(tbl).insert({
            kd_matkul : data.kd_matkul,
            nm_matkul : data.nm_matkul,
            sks : data.sks,
            smt : data.smt
            }).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.error = err;
			res.status(503).json(hasil);
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
	req.checkBody(validator.edit_matkul);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false,
		hasil.error = pesan;
		res.status(422).json(hasil);
	}
	else{
		db(tbl).where(pk,'=',id).update({
            nm_matkul : data.nm_matkul,
            sks : data.sks,
            smt : data.smt
            }).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.error = err;
			res.status(503).json(hasil);
			});
	}
	});
});

module.exports = router;
