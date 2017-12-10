var express = require('express');
var router = express.Router();
var checkData = require('../validator/ujian/create_update');
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
var checkDataSoal = require('../validator/soal/create_update');
var json2csv = require('json2csv')
const excel = require('node-excel-export');

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
router.post('/', (req, res, next) => {
    var data = req.body;
    console.log(data)
    var hasil = {};
    db('tbujian').select('id_ujian').where('id_ujian',data.id_ujian)
    .then(rows=>{
        if(rows.length != 0){
            hasil.status = false
            hasil.err = 2
            reject(res.json(hasil));
        }else return db.transaction(trx=>{
            return trx('tbujian').insert(data).then(()=>{
                    return db('tbkelas_ujian').insert(data.kelas)
                })
            })
        })
    .then(function(){
        hasil.status = true;
        hasil.err = 0
        res.json(hasil);
        }).
    catch(function(err){
        hasil.status = false;
        hasil.err = 1;
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
		hasil.error = err;
		res.status(503).json(hasil);
		});
});
router.put('/:id', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
    db('tbujian').where('id_ujian','=',id).update({
        id_ujian : data.kd_matkul+'-'+data.nidn+'-'+data.tahun_akademik,
        kd_matkul : data.kd_matkul,
        nidn : data.nidn,
        hari : data.hari,
        mulai : data.mulai,
        selesai : data.selesai,
        deskripsi : data.deskripsi,
        id_jujian : data.id_jujian,
        id_jsoal : data.id_jsoal,
        tahun_akademik : data.tahun_akademik,
        id_kelas : data.id_kelas
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

//daftar peserta ujian
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
    query.tmp = db('lap_peserta_ujian').select().where('id_ujian',id).orderByRaw('nm_kelas,nm_mahasiswa asc')
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
router.post('/:id/mahasiswa',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
	db('tbpeserta_ujian').insert(data).then(()=>{
		hasil.status =true;
		hasil.error = null;
		res.send(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.status(503).json(hasil);
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
    var hasil = {}
	var id_ujian = req.params.id
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
		hasil.error = err;
		res.status(503).json(hasil);
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
			hasil.error = err;
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
		res.status(503).json(hasil);
		});
});
//JAWABAN PESERTA ESSSAI
router.get('/:id/jawaban/:idPeserta?',(req, res, next)=>{
	var id_ujian = req.params.id || 0;
	var idPeserta = req.params.idPeserta || 0;
    var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
    var hasil = {}
	var query = db('lap_jawaban').select().where({id_ujian : id_ujian,nobp:idPeserta})
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
		res.status(503).json(hasil);
		});
	});
router.post('/jawaban',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    console.log(data)
	db('tbjawaban').insert(data).then(()=>{
		hasil.status =true;
		hasil.error = null;
		res.send(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.status(503).json(hasil);
		});
    });

//HASIL UJIAN
router.get('/:id/hasil/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var id_mahasiswa = req.params.idPeserta || 0;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
    var hasil = {};
    if(id_mahasiswa == 0){
        var query = db(db.raw("getHasilUjian('"+id+"')")).select().where('id_ujian',id) 
    }else{
        var query = db(db.raw("getHasilUjian('"+id+"')")).select().where({id_ujian:id,nobp:id_mahasiswa}) 
    }
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
		res.status(503).json(hasil);
		});
});
router.post('/hasil', (req, res, next) => {
    var data = req.body;
    var hasil = {};
    db('tbhasil_ujian').insert(data).
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
router.get('/:idUjian/hasil/cetak/csv',(req,res,next)=>{
    let id_ujian = req.params.idUjian
    db(db.raw("getHasilUjian('"+id_ujian+"')")).select('nobp','nm_mahasiswa','nilai').orderBy('nm_mahasiswa','asc')
    .then(function(rows){
        var data = rows
        var fields = ['nobp','nm_mahasiswa','nilai']
        var fieldsName = ['NOBP','Nama Mahasiswa','Nilai']
        json2csv({ data: data, fields: fields, fieldNames : fieldsName }, function(err, csv) {
          if (err) console.log(err);
          res
            .header('Content-type','text/csv')
            .header("Content-Disposition", "attachment;filename=laporan_nilai.csv")
            .send(csv)
		})
        }).
	catch(function(err){
		res.json(err);
		});
    });
router.get('/:idUjian/hasil/cetak/excel',(req,res,next)=>{
    let id_ujian = req.params.idUjian
    let header = {
        fill: {
          fgColor: {
            rgb: 'E0E0E0'
          }
        },
        font: {
          sz: 12,
          bold: true
        }
    }
    const dataConf = {
      nobp: { // <- the key should match the actual data key 
        displayName: 'NOBP', // <- Here you specify the column header 
        headerStyle: header
      },
      nm_mahasiswa: { // <- the key should match the actual data key 
        displayName: 'Nama Mahasiswa', // <- Here you specify the column header 
        headerStyle: header
      },
      nilai: { // <- the key should match the actual data key 
        displayName: 'Nilai', // <- Here you specify the column header 
        headerStyle: header
      }
    }
    db(db.raw("getHasilUjian('"+id_ujian+"')")).select('nobp','nm_mahasiswa','nilai').orderBy('nm_mahasiswa','asc')
    .then(function(rows){
          const report = excel.buildExport(
          [ // <- Notice that this is an array. Pass multiple sheets to create multi sheet report 
            {
              name: 'Report', // <- Specify sheet name (optional) 
              //heading: heading, // <- Raw heading array (optional) 
              //merges: merges, // <- Merge cell ranges 
              specification: dataConf, // <- Report specification 
              data: rows // <-- Report data 
            }
          ]
        );
        res.header('Content-type','application/vnd.ms-excel')
        .header("Content-Disposition", "attachment;filename=laporan_nilai_"+id_ujian+".xlsx")
        .send(report)
        }).
	catch(function(err){
		res.json(err);
		});
    });
module.exports = router;
