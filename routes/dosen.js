var express = require('express');
var router = express.Router();
var validator = require('../validator/validator');
var pk = 'id_dosen';
var tbl = 'tbdosen';
var json2csv = require('json2csv')
var _ = require('lodash')

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

//pencarian dosen
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
	req.checkBody(validator.dosen);
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
            nidn : data.nidn,
            nm_dosen : data.nm_dosen
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
	req.checkBody(validator.edit_dosen);
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
            nm_dosen : data.nm_dosen
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

//lihat kuliah yg diampu dosen
router.get('/:id/kuliah/:idKuliah?',(req, res, next)=>{
	var id = req.params.id || 0;
	var idKuliah = req.params.idKuliah;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    var thn = req.query.thn || "2"
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    if(idKuliah){
        query.count = db('lap_kuliah').select("nidn").where({nidn:id,id_kuliah:idKuliah})
        query.tmp = db('lap_kuliah').select("*",db.raw("array_to_string(nm_kelas,',') as ket_nm_kelas")).where({nidn:id,id_kuliah:idKuliah})
        }
    else{
        query.count = db('lap_kuliah').select("nidn").where('nidn',id).andWhere("tahun_akademik","like","%"+thn+"%")
        query.tmp = db('lap_kuliah').select("*",db.raw("array_to_string(nm_kelas,',') as ket_nm_kelas")).where('nidn',id).andWhere("tahun_akademik","like","%"+thn+"%")
    }
    
    if(limit == null && offset == null) {
        query.show = query.tmp
    }
    else {
        query.show = query.tmp.limit(limit).offset(offset)
    }
	query.show.then(function(rows){
        if(idKuliah) rows.id_kelas = rows.nm_kelas
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
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});

//DOSEN MENGELOLA KULIAH
router.post('/:id/kuliah',(req,res,next)=>{
	var data = req.body;
    
	var hasil = {};
    var id = req.params.id
    req.checkBody(validator.dosen_kuliah);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == true){
        db('tbkuliah').insert({
            id_kuliah : data.kd_matkul+"-"+id+"-"+data.tahun_akademik,
            nidn : id,
            kd_matkul : data.kd_matkul,
            tahun_akademik : data.tahun_akademik,
            }).
        then((rows)=>{
            let kelas = []
            _.forEach(data.kelas,(v,k)=>{
                kelas.push({id_kuliah:data.kd_matkul+"-"+id+"-"+data.tahun_akademik,id_kelas:v})
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
            res.status(500).json(hasil);
            });
    }
    else {
        hasil.status = false;
		hasil.error = pesan;
		res.status(422).json(hasil); 
    }
	});
});
router.put('/:nidn/kuliah/:id',(req,res,next)=>{
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
//EOF DOSEN MENGELOLA KULIAH

//DOSEN MENGELOLA UJIAN
router.get('/:id/ujian/:idUjian?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    let id_ujian = req.params.idUjian
    let thn = req.query.thn || "2"
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    if(id_ujian){
        query.count = db('lap_ujian').select("id_ujian").where('id_ujian',id_ujian)
        query.tmp = db('lap_ujian').select("*",db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu")).where('id_ujian',id_ujian)
    }else{
        query.count = db('lap_ujian').select("id_ujian").where('nidn',id).andWhere("tahun_akademik","like","%"+thn+"%")
        query.tmp = db('lap_ujian').select("*",db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu")).where('nidn',id).orderBy('hari','desc').andWhere("tahun_akademik","like","%"+thn+"%")
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
router.post('/:id/ujian', (req, res, next) => {
    var data = req.body;
    var id = req.params.id
    
    var hasil = {};
    req.checkBody(validator.ujian);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == true){
        db('tbujian').insert({
            id_ujian : data.id_kuliah+'-'+data.id_jujian,
            hari : data.hari,
            mulai : data.mulai,
            selesai : data.selesai,
            deskripsi : data.deskripsi,
            id_jujian : data.id_jujian,
            id_jsoal : data.id_jsoal,
            id_kuliah : data.id_kuliah
            })
        .then(function(rows){
            hasil.status = true;
            res.json(hasil);
            }).
        catch(function(err){
            
            hasil.status = false;
            res.status(500).json(hasil);
            });
        }else{
            hasil.status = false;
            hasil.error = pesan;
            res.status(422).json(hasil); 
        }
    });
});
router.put('/:id/ujian/:idUjian', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var id_ujian = req.params.idUjian;
    var hasil = {};
    req.checkBody(validator.edit_ujian);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false;
		hasil.error = pesan;
        res.status(422).json(hasil);
	}
	else{
        db('tbujian').where('id_ujian','=',id_ujian).update({
            hari : data.hari,
            mulai : data.mulai,
            selesai : data.selesai,
            deskripsi : data.deskripsi
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
router.delete('/:id/ujian/:idUjian', (req, res, next) => {
    var id = req.params.id;
    var id_ujian = req.params.idUjian
    var hasil = {};
	db('tbujian').where('id_ujian',id_ujian).del().
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
//EOF DOSEN MENGELOLA UJIAN
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
		hasil.error = err;
		res.status(503).json(hasil);
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
