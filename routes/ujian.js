var express = require('express');
var router = express.Router();
var validator = require('../validator/validator');
var json2csv = require('json2csv')
var axios = require('axios')
const excel = require('node-excel-export');
_ = require('lodash')
var Excel = require('exceljs');
var formatWaktu = require('date-fns/format')
var lokalisasi = require('date-fns/locale/id')
let tmp_file = require('tempfile')
router.get('/:id?', (req, res, next) => {
    var id = req.params.id || 0;
    var nidn = req.query.nidn || 0;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
    var hasil = {};
    let query = {
        show: null,
        count: null,
        tmp: null
    }
    if (id == 0) {
        query.count = db('lap_ujian').select("*", db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu"))
        query.tmp = db('lap_ujian').select("*", db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu"))
    } else {
        query.count = db('lap_ujian').select("*", db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu")).where('id_ujian', id)
        query.tmp = db('lap_ujian').select("*", db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu")).where('id_ujian', id)
    }
    if (limit == null) query.show = query.tmp
    else query.show = query.tmp.limit(limit).offset(offset)
    query.show.then(function (rows) {
        console.log(rows)
        hasil.status = true;
        hasil.data = rows;
        hasil.current_row = rows.length;
        return query.count;
    }).
    then((rows) => {
        let code
        hasil.row = rows.length
        if (rows.length == 0) code = 204
        else code = 200
        res.status(code).json(hasil);
    }).
    catch(function (err) {
        hasil.status = false
        hasil.error = err;
        res.status(503).json(hasil);
    });
});

router.post('/', (req, res, next) => {
    var data = req.body;
    console.log(data)
    var hasil = {};
    req.checkBody(validator.ujian);
    req.getValidationResult().then(function (result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            hasil.status = false;
            hasil.error = pesan;
            res.status(422).json(hasil);
        } else {
            db('tbujian').insert({
                    id_ujian: data.id_kuliah + '-' + data.id_jujian,
                    hari: data.hari,
                    mulai: data.mulai,
                    selesai: data.selesai,
                    deskripsi: data.deskripsi,
                    id_jujian: data.id_jujian,
                    id_jsoal: data.id_jsoal,
                    id_kuliah: data.id_kuliah
                })
                .then(function (rows) {
                    hasil.status = true;
                    res.json(hasil);
                }).
            catch(function (err) {
                console.log(err)
                hasil.status = false;
                res.status(500).json(hasil);
            });
        }
    });
});
router.delete('/:id', (req, res, next) => {
    var id = req.params.id;
    var hasil = {};
    db('tbujian').where('id_ujian', id).del().
    then(function () {
        hasil.status = true;
        res.json(hasil);
    }).
    catch(function (err) {
        hasil.status = false;
        hasil.error = err;
        res.status(503).json(hasil);
    });
});
router.put('/:id', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
    req.checkBody(validator.edit_ujian);
    req.getValidationResult().then(function (result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            hasil.status = false;
            hasil.error = pesan;
            res.status(422).json(hasil);
        } else {
            db('tbujian').where('id_ujian', '=', id).update({
                hari: data.hari,
                mulai: data.mulai,
                selesai: data.selesai,
                deskripsi: data.deskripsi
            }).
            then(function () {
                hasil.status = true;
                res.json(hasil);
            }).
            catch(function (err) {
                hasil.status = false;
                hasil.error = err;
                res.status(503).json(hasil);
            });
        }
    });
});
//daftar peserta ujian
router.get('/:id/mahasiswa', (req, res, next) => {
    var id = req.params.id || 0;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
    var hasil = {};
    let query = {
        show: null,
        count: null,
        tmp: null
    }
    query.count = db('lap_peserta_ujian').select('nobp').where('id_ujian', id)
    query.tmp = db('lap_peserta_ujian').select().where('id_ujian', id).orderByRaw('nm_kelas,nm_mahasiswa asc')
    if (limit == null && offset == null) {
        query.show = query.tmp
    } else {
        query.show = query.tmp.limit(limit).offset(offset)
    }
    query.show.then(function (rows) {
        hasil.status = true;
        hasil.data = rows;
        hasil.current_row = rows.length;
        return query.count
    }).
    then((rows) => {
        let code
        hasil.row = rows.length
        if (rows.length == 0) code = 204
        else code = 200
        res.status(code).json(hasil);
    }).
    catch(function (err) {
        hasil.status = false
        hasil.error = err;
        res.status(503).json(hasil);
    });
});
//Soal Ujian
router.get('/:id/soal', (req, res, next) => {
    var id = req.params.id;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
    var hasil = {};
    let query = {
        show: null,
        count: null,
        tmp: null
    }
    query.count = db('lap_soal_ujian').select().where('id_ujian', id)
    query.tmp = db('lap_soal_ujian').select().where('id_ujian', id)
    if (limit == null && offset == null) {
        query.show = query.tmp
    } else {
        query.show = query.tmp.limit(limit).offset(offset)
    }
    query.show.then(function (rows) {
        hasil.status = true;
        hasil.data = rows;
        hasil.current_row = rows.length;
        return query.count
    }).
    then((rows) => {
            let code
            hasil.row = rows.length
            if (rows.length == 0) code = 204
            else code = 200
            res.status(code).json(hasil);
        })
        .catch(function (err) {
            hasil.status = false
            hasil.error = err;
            res.status(503).json(hasil);
        });
});
router.post('/:id/soal/', (req, res, next) => {
    var data = req.body;
    var hasil = {}
    if (data.id_jsoal == 1) {
        data.bobot = 1
    } else {
        data.jawaban = " - "
        data.pilihanGanda = [{}]
    }
    var id_ujian = req.params.id
    req.checkBody(validator.soal);
    req.getValidationResult().then(function (result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            hasil.status = false;
            hasil.error = pesan;
            console.log(pesan)
            res.status(422).json(hasil);
        } else {
            db('tbsoal').insert({
                isi_soal: data.isi_soal,
                jawaban: data.jawaban,
                pilihanGanda: JSON.stringify(data.pilihanGanda),
                id_jsoal: data.id_jsoal,
                bobot: data.bobot
            }).returning('id_soal').then((id) => {
                return db('tbsoal_ujian').insert({
                    id_ujian: id_ujian,
                    id_soal: parseInt(id)
                })
            }).
            then(() => {
                hasil.status = true;
                hasil.error = null;
                res.send(hasil);
            }).
            catch(function (err) {
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
    req.checkBody(validator.soal);
    req.getValidationResult().then(function (result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            hasil.status = false;
            hasil.error = pesan;
            res.status(422).json(hasil);
        } else {
            db('tbsoal').update({
                isi_soal: data.isi_soal,
                jawaban: data.jawaban,
                pilihanGanda: JSON.stringify(data.pilihanGanda),
                id_tsoal: data.id_tsoal,
                bobot: data.bobot
            }).where('id_soal', id_soal).
            then(function () {
                hasil.status = true;
                hasil.error = null;
                res.send(hasil);
            }).
            catch(function (err) {
                hasil.status = false;
                hasil.error = err;
                res.status(503).json(hasil);
            });
        }
    });
});
router.delete('/:id/soal/:idSoal', (req, res, next) => {
    var id = req.params.id;
    var id_soal = req.params.idSoal;
    var data = req.body;
    var hasil = {};
    db('tbsoal_ujian').where({
            id_soal: id_soal,
            id_ujian: id
        }).del()
        .then(() => {
            hasil.status = true;
            res.json(hasil);
        })
        .catch((err) => {
            hasil.status = false;
            hasil.error = err;
            res.status(503).json(hasil);
        });
});
//JAWABAN PESERTA ESSSAI
router.get('/:id/jawaban/:idPeserta?', (req, res, next) => {
    var id_ujian = req.params.id || 0;
    var idPeserta = req.params.idPeserta || 0;
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
    var hasil = {}
    var query = db('lap_jawaban').select().where({
        id_ujian: id_ujian,
        nobp: idPeserta
    })
    query.then(function (rows) {
        hasil.status = true;
        hasil.data = rows;
        hasil.current_row = rows.length;
        hasil.row = rows.length
        res.send(hasil);
    }).
    catch(function (err) {
        hasil.status = false
        hasil.error = err;
        res.status(503).json(hasil);
    });
});
router.post('/jawaban', (req, res, next) => {
    var data = req.body;
    var hasil = {};
    var data_tmp = []
    _.forEach(data, (v, k) => {
        data_tmp.push({
            id_ujian: v.id_ujian,
            nobp: v.nobp,
            jawaban: v.jawaban,
            id_soal: v.id_soal
        })
    });
    console.log(data_tmp)
    db('tbjawaban').insert(data_tmp).then(() => {
        hasil.status = true;
        hasil.error = null;
        res.send(hasil);
    }).
    catch(function (err) {
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
    let query = {
        show: null,
        count: null,
        tmp: null
    }
    query.count = db(db.raw("getHasilUjian('" + id + "')")).select(db.raw('distinct(nobp),id_ujian,nm_mahasiswa,id_kelas,nm_kelas,nilai,status_ujian_peserta,nm_status_ujian_peserta')).where('id_ujian', id)
    query.tmp = db(db.raw("getHasilUjian('" + id + "')")).select(db.raw('distinct(nobp),id_ujian,nm_mahasiswa,id_kelas,nm_kelas,nilai,status_ujian_peserta,nm_status_ujian_peserta')).where('id_ujian', id)
    if (limit == null) query.show = query.tmp
    else query.show = query.tmp.limit(limit).offset(offset)
    query.show.then(function (rows) {
            hasil.status = true;
            hasil.data = rows;
            hasil.current_row = rows.length;
        })
        .then(() => {
            return query.count;
        })
        .then((jumlah) => {
            let code
            hasil.row = jumlah.length;
            if (hasil.row == 0) code = 204
            else code = 200
            res.status(code).json(hasil);
        })
        .catch((err) => {
            hasil.status = false;
            hasil.error = err;
            res.status(503).json(hasil);
        });
});
router.post('/hasil', (req, res, next) => {
    var data = req.body;
    var hasil = {};
    db('tbhasil_ujian').insert({
        id_ujian: data.id_ujian,
        nobp: data.nobp,
        nilai: data.nilai
    }).
    then(function () {
        hasil.status = true;
        res.json(hasil);
    }).
    catch(function (err) {
        hasil.status = false;
        hasil.error = err;
        res.json(hasil);
    });
});
router.get('/:idUjian/hasil/cetak/csv', (req, res, next) => {
    let id_ujian = req.params.idUjian
    db(db.raw("getHasilUjian('" + id_ujian + "')")).select('nobp', 'nm_mahasiswa', 'nilai').orderBy('nm_mahasiswa', 'asc')
        .then(function (rows) {
            var data = rows
            var fields = ['nobp', 'nm_mahasiswa', 'nilai']
            var fieldsName = ['NOBP', 'Nama Mahasiswa', 'Nilai']
            json2csv({
                data: data,
                fields: fields,
                fieldNames: fieldsName
            }, function (err, csv) {
                if (err) console.log(err);
                res
                    .header('Content-type', 'text/csv')
                    .header("Content-Disposition", "attachment;filename=laporan_nilai.csv")
                    .send(csv)
            })
        }).
    catch(function (err) {
        res.json(err);
    });
});
router.get('/:idUjian/hasil/cetak/excel', (req, res, next) => {
    let id_ujian = req.params.idUjian
    var workbook = new Excel.Workbook();
    var worksheet = workbook.addWorksheet('Hasil Ujian');
    db('lap_ujian').select("*", db.raw("concat(to_char(hari,'dd TMMonth yyyy'),' ',mulai,'-',selesai) as ket_waktu")).where('id_ujian',id_ujian)
        .then((rows)=>{
            var hasil = rows[0]
            worksheet.addRow(['LAPORAN HASIL UJIAN'])
            worksheet.addRow(['Mata Kuliah',hasil.nm_matkul])
            worksheet.addRow(['Dosen',hasil.nm_dosen])
            worksheet.addRow(['Kelas',hasil.nm_kelas.toString()])
            worksheet.addRow(['Tahun Akademik',hasil.tahun_akademik])
            worksheet.addRow(['Hari',formatWaktu(new Date(hasil.hari), 'DD MMMM YYYY', {locale : lokalisasi})])
            worksheet.addRow(['Jam',hasil.mulai+' - '+hasil.selesai])
            worksheet.addRow(['Jenis Ujian',hasil.nm_jujian])
            worksheet.addRow(['Jenis Soal',hasil.nm_jsoal])
            return db(db.raw("getHasilUjian('" + id_ujian + "')")).select(db.raw('distinct(nobp),id_ujian,nm_mahasiswa,id_kelas,nm_kelas,nilai,status_ujian_peserta,nm_status_ujian_peserta')).where('id_ujian', id_ujian).orderBy('nobp','asc')
        })
        .then(function (rows) {
            var fontHeader = {
                size : 12,
                bold : true
            }
            var fillHeader = {
                type: 'pattern',
                pattern:'solid',
                fgColor:{argb:'00DFE2E5'}
            }
            worksheet.addRow([])
            worksheet.addRow(['NOBP','Nama','Kelas','Status','Nilai'])
            _.forEach(rows,(v,k) => {
                worksheet.addRow([v.nobp,v.nm_mahasiswa,v.nm_kelas,v.nm_status_ujian_peserta,v.nilai])
            });
            //style
            worksheet.getRow(11).alignment = {vertical : "middle",horizontal: "center"}
            for(var x=2;x<=9;x++){
                worksheet.mergeCells('B'+x+':E'+x)
                worksheet.getCell('A'+x).font = fontHeader
            }
            worksheet.mergeCells('A1:E1')
            worksheet.getCell('A1').alignment = {vertical : "middle",horizontal: "center"}
            worksheet.getCell('A1').font = {
                size : 17,
                bold : true
            }
            worksheet.getCell('A11').font = fontHeader
            worksheet.getCell('B11').font = fontHeader
            worksheet.getCell('C11').font = fontHeader
            worksheet.getCell('D11').font = fontHeader
            worksheet.getCell('E11').font = fontHeader
            worksheet.getCell('A11').fill = fillHeader
            worksheet.getCell('B11').fill = fillHeader
            worksheet.getCell('C11').fill = fillHeader
            worksheet.getCell('D11').fill = fillHeader
            worksheet.getCell('E11').fill = fillHeader
            
            for(var x = 2;x <= 9;x++){
                worksheet.getCell('A'+x).font = fillHeader
            }
            worksheet.getCell('A1').border = {
                top: {style:'thin'},
                left: {style:'thin'},
                bottom: {style:'thin'},
                right: {style:'thin'}
            };
            //enof style
            var file_tmp = tmp_file('.xlsx')
            workbook.xlsx.writeFile(file_tmp).then(()=>{
                res.download(file_tmp,id_ujian+'.xlsx')
            })
        })
        .catch(function (err) {
            res.json(err);
        });
});

//get rata
router.get('/nilai/rata/:url_cari?/:cari?', (req, res, next) => {
    var limit = parseInt(req.query.limit) || null;
    var offset = parseInt(req.query.offset) || null;
    var hasil = {};
    var cari = req.params.cari
    var url_cari = req.params.url_cari
    let query = {
        show: null,
        count: null,
        tmp: null
    }
    if (cari != null && url_cari != null) {
        query.count = db('nilai_rata').select().where("nm_matkul", "like", '%' + cari + '%').orWhere(db.raw('lower(nm_dosen)'), 'like', '%' + cari + '%').orWhere("nm_jujian", "like", '%' + cari + '%')
        query.tmp = db('nilai_rata').select().where("nm_matkul", "like", '%' + cari + '%').orWhere(db.raw('lower(nm_dosen)'), 'like', '%' + cari + '%').orWhere("nm_jujian", "like", '%' + cari + '%')
    } else {
        query.count = db('nilai_rata').select()
        query.tmp = db('nilai_rata').select()
    }
    if (limit == null) query.show = query.tmp
    else query.show = query.tmp.limit(limit).offset(offset)
    query.show.then(function (rows) {
        hasil.status = true;
        hasil.data = rows;
        hasil.current_row = rows.length;
        return query.count;
    }).
    then((rows) => {
        let code
        hasil.row = rows.length
        if (rows.length == 0) code = 204
        else code = 200
        res.status(code).json(hasil);
    }).
    catch(function (err) {
        hasil.status = false
        hasil.error = err;
        res.status(503).json(hasil);
    });
});
module.exports = router;