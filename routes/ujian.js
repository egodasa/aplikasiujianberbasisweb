var express = require('express');
var router = express.Router();
var checkData = require('../validator/ujian/create_update');
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
var checkDataSoal = require('../validator/soal/create_update');

router.get('/:id?', (req, res, next) => {
	var id = req.params.id || 0;
	var nidn = req.query.nidn || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    if(id == 0){
         query.count = db('lap_ujian').select()
         query.tmp = db('lap_ujian').select()
    }
    else{
        query.count = db('lap_ujian').select().where('id_ujian',id)
        query.tmp = db('lap_ujian').select().where('id_ujian',id)
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
		hasil.row = rows.length
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
    });
router.post('/', (req, res, next) => {
    var data = req.body;
    var hasil = {};
    db('tbujian').insert(data).
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

//daftar peserta ujian
//daftar ujian yang diikuti peserta
router.get('/:id/mahasiswa',(req, res, next)=>{
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
    query.count = db('lap_peserta_ujian').select('nobp').where('id_ujian',id)
    query.tmp = db('lap_peserta_ujian').select('nobp','nm_mahasiswa').where('id_ujian',id)
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

//Soal Ujian
router.get('/:id/soal', (req, res, next) => {
    var id = req.params.id;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
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
        id_jsoal:data.id_jsoal,
        bobot:data.bobot
        }).returning('id_soal').then((id)=>{
		return db('tbsoal_ujian').insert({id_ujian:id_ujian,id_soal:parseInt(id)})
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
router.get('/:id/jawaban',(req, res, next)=>{
	var id_ujian = req.params.id || 0;
	var idPeserta = req.params.idPeserta || 0;
    var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    var hasil = {}
	db.raw("SELECT lap_peserta_ujian.id_mahasiswa, lap_peserta_ujian.nobp, lap_peserta_ujian.nm_mahasiswa, CASE WHEN (hasil_ujian.jawaban IS NOT NULL) THEN true ELSE false END AS status, hasil_ujian.id_tsoal FROM (lap_peserta_ujian LEFT JOIN ( SELECT distinct on (tbjawaban.id_peserta) tbjawaban.id_jawaban, tbjawaban.id_ujian, tbjawaban.id_peserta, tbjawaban.jawaban, tbujian.id_tsoal FROM (tbjawaban JOIN tbujian ON ((tbjawaban.id_ujian = tbujian.id_ujian))) WHERE (tbjawaban.id_ujian = ?)) hasil_ujian ON ((lap_peserta_ujian.id_mahasiswa = hasil_ujian.id_peserta))) where lap_peserta_ujian.id_ujian=? LIMIT ? OFFSET ?",[id_ujian,id_ujian,limit,offset])
	.then(function(rows){
		hasil.status = true;
		hasil.data = rows.rows;
        hasil.current_row = rows.rows.length;
        return db.raw("SELECT lap_peserta_ujian.id_mahasiswa, lap_peserta_ujian.nobp, lap_peserta_ujian.nm_mahasiswa, CASE WHEN (hasil_ujian.jawaban IS NOT NULL) THEN true ELSE false END AS status, hasil_ujian.id_tsoal FROM (lap_peserta_ujian LEFT JOIN ( SELECT distinct on (tbjawaban.id_peserta) tbjawaban.id_jawaban, tbjawaban.id_ujian, tbjawaban.id_peserta, tbjawaban.jawaban, tbujian.id_tsoal FROM (tbjawaban JOIN tbujian ON ((tbjawaban.id_ujian = tbujian.id_ujian))) WHERE (tbjawaban.id_ujian = ?)) hasil_ujian ON ((lap_peserta_ujian.id_mahasiswa = hasil_ujian.id_peserta))) where lap_peserta_ujian.id_ujian=?",[id_ujian,id_ujian])
		})
    .then((rows)=>{
        hasil.row = rows.rows.length
        res.send(hasil);
        }).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});
router.get('/:id/jawaban/:idPeserta?',(req, res, next)=>{
	var id_ujian = req.params.id || 0;
	var idPeserta = req.params.idPeserta || 0;
    var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    var hasil = {}
	var query = db('lap_jawaban').select().where({id_ujian : id_ujian,id_peserta:idPeserta})
    query.then(function(rows){
		hasil.status = true;
		hasil.data = rows;
        hasil.current_row = rows.length;
        hasil.row = rows.length
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
	db('tbhasil_ujian').insert(data).then(()=>{
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

//HASIL UJIAN
router.get('/:id/hasil/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var id_mahasiswa = req.params.idPeserta || 0;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
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
