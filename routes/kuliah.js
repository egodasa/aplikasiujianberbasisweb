var express = require('express');
var router = express.Router();
var pk = 'id_kuliah';
var tbl = 'tbkuliah';
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
         query.count = db('lap_kuliah').select()
         //query.tmp = db('lap_kuliah').select().where(req.query)
         query.tmp = db('lap_kuliah').select()
    }
    else{
        query.count = db('lap_kuliah').select().where('id_kuliah',id)
        query.tmp = db('lap_kuliah').select().where('id_kuliah',id)
    }
    if(limit == null) query.show = query.tmp
    else query.show = query.tmp.limit(limit).offset(offset)
	query.show.then(function(rows){
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return query.count;
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
        hasil.error = err;
        res.json(hasil);
        });
	}); 
router.put('/:id',(req,res,next)=>{
    var id= req.params.id
	var data = req.body;
	var hasil = {};
    console.log(data)
    db(tbl).update({
        nidn : data.nidn,
        kd_matkul : data.kd_matkul,
        tahun_akademik : data.tahun_akademik,
        }).where('id_kuliah',data.id_kuliah)
    then(function(){
        hasil.status = true;
        res.json(hasil);
        }).
    catch(function(err){
        hasil.status = false;
        hasil.error = err;
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
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});

//Mahasiswa pada sebuah kuliah
router.get('/:id/mahasiswa',(req, res, next)=>{
	var id = req.params.id;
    var hasil = {};
    var limit = parseInt(parseInt(req.query.limit)) || null;
	var offset = parseInt(parseInt(req.query.offset)) || null;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    if(belumDitambahkan == 0) var query = db('lap_peserta_kuliah').select().where('id_kuliah',id)
    else {
        var query = db('lap_peserta_kuliah').select('nobp').where('id_kuliah',id)
        query = db('tbmahasiswa').select().whereNotIn('nobp',query)
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
		res.status(503).json(hasil);
		});
	});
router.post('/:id/mahasiswa',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
    db('tbpeserta_kuliah').insert(data).
    then(function(){
        hasil.status = true;
        res.json(hasil);
        }).
    catch(function(err){
        console.log(err)
        hasil.status = false;
        hasil.error = err;
        res.json(hasil);
        });
	}); 
router.delete('/:id/mahasiswa/:idMhs',(req,res,next)=>{
	var id_mhs = req.params.idMhs;
	var hasil = {};
	db('tbpeserta_kuliah').where('id_peserta',id_mhs).del().
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

module.exports = router;
