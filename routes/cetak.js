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

router.get('/:idUjian/hasil/csv', (req, res, next) => {
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
            return db(db.raw("getHasilUjian('" + id_ujian + "')")).select(db.raw('distinct(nobp),id_ujian,nm_mahasiswa,id_kelas,nm_kelas,nilai')).where('id_ujian', id_ujian).orderBy('nobp','asc')
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
            worksheet.addRow(['No','NOBP','Nama','Kelas','Nilai'])
            _.forEach(rows,(v,k) => {
                worksheet.addRow([k+1,v.nobp.toString(),v.nm_mahasiswa,v.nm_kelas,v.nilai])
            });
            /*
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
            */
            var file_tmp = tmp_file('.csv')
            workbook.csv.writeFile(file_tmp).then(()=>{
                res.download(file_tmp,id_ujian+'.csv')
            })
        })
        .catch(function (err) {
            res.json(err);
        });
});
router.get('/:idUjian/hasil/excel', (req, res, next) => {
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
            return db(db.raw("getHasilUjian('" + id_ujian + "')")).select(db.raw('distinct(nobp),id_ujian,nm_mahasiswa,id_kelas,nm_kelas,nilai')).where('id_ujian', id_ujian).orderBy('nobp','asc')
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
            worksheet.addRow(['No','NOBP','Nama','Kelas','Nilai'])
            _.forEach(rows,(v,k) => {
                worksheet.addRow([k+1,v.nobp,v.nm_mahasiswa,v.nm_kelas,v.nilai])
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

module.exports = router;
