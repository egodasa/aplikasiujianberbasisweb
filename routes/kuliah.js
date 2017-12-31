var express = require('express');
var router = express.Router();
var _ = require('lodash')
var pk = 'id_kuliah';
var tbl = 'tbkuliah';
var validator = require('../validator/validator');
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
         query.count = db('lap_kuliah').select("*",db.raw("array_to_string(nm_kelas,',') as ket_nm_kelas"))
         //query.tmp = db('lap_kuliah').select().where(req.query)
         query.tmp = db('lap_kuliah').select("*",db.raw("array_to_string(nm_kelas,',') as ket_nm_kelas"))
    }
    else{
        query.count = db('lap_kuliah').select("*",db.raw("array_to_string(nm_kelas,',') as ket_nm_kelas")).where('id_kuliah',id)
        query.tmp = db('lap_kuliah').select("*",db.raw("array_to_string(nm_kelas,',') as ket_nm_kelas")).where('id_kuliah',id)
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
    req.checkBody(validator.kuliah);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false,
		hasil.error = pesan;
		res.status(422).json(hasil);
	}
	else{
        db(tbl).insert({
            id_kuliah : data.kd_matkul+"-"+data.nidn+"-"+data.tahun_akademik,
            nidn : data.nidn,
            kd_matkul : data.kd_matkul,
            tahun_akademik : data.tahun_akademik
            }).
        then((rows)=>{
            let kelas = []
            _.forEach(data.kelas,(v,k)=>{
                kelas.push({id_kuliah:data.kd_matkul+"-"+data.nidn+"-"+data.tahun_akademik,id_kelas:v})
                })
            return db('tbkelas_kuliah').insert(kelas)
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
router.put('/:id',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    var id = req.params.id
    req.checkBody(validator.update_kuliah);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false,
		hasil.error = pesan;
		res.status(422).json(hasil);
	}
	else{
        db(tbl).update({
            tahun_akademik : data.tahun_akademik
            }).
        then((rows)=>{
            return db('tbkelas_kuliah').where('id_kuliah',id).del()
            }).
        then((rows)=>{
            let kelas = []
            _.forEach(data.kelas,(v,k)=>{
                kelas.push({id_kuliah:id,id_kelas:v})
                })
            return db('tbkelas_kuliah').insert(kelas)
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
	var id = req.params.id;
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
		let code
		hasil.row = jumlah[0].jumlah;
        if(hasil.row == 0) code = 204
        else code = 200
		res.status(code).json(hasil); 
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});
router.post('/:id/mahasiswa',(req,res,next)=>{
	var data = req.body;
    console.log(data)
	var hasil = {};
    var id = req.params.id
    req.checkBody(validator.peserta_kuliah);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false,
		hasil.error = pesan;
		res.status(422).json(hasil);
	}
	else{
        let data_send = []
        _.forEach(data.nobp,(v,k)=>{
            data_send.push({
            id_peserta : v+'-'+id,
            nobp : v,
            id_kuliah : id,
            id_kelas : data.id_kelas
            })
            })
        db('tbpeserta_kuliah').insert(data_send).
        then(function(){
            hasil.status = true;
            res.json(hasil);
            }).
        catch(function(err){
            console.log(err)
            hasil.status = false;
            hasil.error = err;
            res.status(503).json(hasil);
            });
        }
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
