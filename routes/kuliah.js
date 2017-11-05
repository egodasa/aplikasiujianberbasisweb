var express = require('express');
var router = express.Router();
var pk = 'id_kuliah';
var tbl = 'tbkuliah';
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
	db('lap_kuliah').select().limit(limit).offset(offset).where(pk,op,id).
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
	}); 
router.put('/:id',(req,res,next)=>{
    var id= req.params.id
	var data = req.body;
	var hasil = {};
    console.log(data)
    db(tbl).update(data).where(pk,id)
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

//Mahasiswa pada sebuah kuliah
router.get('/:id/mahasiswa',(req, res, next)=>{
	var id = req.params.id;
    var hasil = {};
    var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    if(belumDitambahkan == 0) var query = db('lap_kuliah_mhs').select().where('id_kuliah',id)
    else {
        var query = db('lap_kuliah_mhs').select('id_mahasiswa').where('id_kuliah',id)
        query = db('tbmahasiswa').select().whereNotIn('id_mahasiswa',query)
    }
	query.limit(limit).offset(offset).
	then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return query.count('* as jumlah');
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
router.post('/:id/mahasiswa',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
    db('tbkuliah_mhs').insert(data).
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
router.delete('/:id/mahasiswa/:idMhs',(req,res,next)=>{
	var id_mhs = req.params.idMhs;
	var hasil = {};
	db('tbkuliah_mhs').where('id_kmhs',id_mhs).del().
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
