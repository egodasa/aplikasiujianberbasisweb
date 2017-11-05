var express = require('express');
var router = express.Router();
var checkData = require('../validator/matkul/create_update');
var pk = 'id_matkul';
var tbl = 'tbmatkul';
router.get('/:id?',(req, res, next)=>{
	var id_tmp = req.params.id;
    var id = null;
    id_tmp == undefined ? id = 0 : id = id_tmp;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
	var op = null;
	if(id == 0) op = "!=";
	else op = "=";
	db(tbl).select().limit(limit).offset(offset).where(pk,op,id).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db(tbl).count(pk+' as jumlah');
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

//Matkul Dosen
router.get('/:idMatkul/dosen',(req, res, next)=>{
	var id_matkul = req.params.idMatkul;
	var limit = 1*req.query.limit || null;
	var offset = 1*req.query.offset || null;
	var hasil = {};
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    if(belumDitambahkan == 'ya'){
        var query = db('lap_matkul_dosen').select("id_dosen").limit(limit).offset(offset).where('id_matkul','=',id_matkul);
        query = db('tbdosen').select().whereNotIn("id_dosen",query)
    }else var query = db('lap_matkul_dosen').select().limit(limit).offset(offset).where('id_matkul','=',id_matkul);
    query.
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return db('lap_matkul_dosen').count(pk+' as jumlah');
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
router.post('/:id/dosen',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
    db('tbmatkul_dosen').insert(data).
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
router.delete('/:id/dosen/:id_dosen',(req,res,next)=>{
	var id_dosen = req.params.id_dosen;
	var hasil = {};
	db('tbmatkul_dosen').where('id_mdosen',id_dosen).del().
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

module.exports = router;
