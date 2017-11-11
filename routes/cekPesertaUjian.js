var express = require('express');
var router = express.Router();
router.get('/:id_tsoal/ujian/:id_ujian/peserta/:nobp',(req, res, next)=>{
	var id_tsoal = req.params.id_tsoal
    var nobp = req.params.nobp
    var id_ujian = req.params.id_ujian
    var hasil = {}
    var query
    if(id_tsoal == 2){
        query = db.raw("SELECT distinct on(lap_peserta_ujian.nm_mahasiswa) lap_peserta_ujian.id_mahasiswa, lap_peserta_ujian.nobp, lap_peserta_ujian.nm_mahasiswa, CASE WHEN (hasil_ujian.jawaban IS NOT NULL) THEN true ELSE false END AS status, hasil_ujian.id_tsoal FROM (lap_peserta_ujian LEFT JOIN ( SELECT tbjawaban.id_jawaban, tbjawaban.id_ujian, tbjawaban.id_peserta, tbjawaban.jawaban, tbujian.id_tsoal FROM (tbjawaban JOIN tbujian ON ((tbjawaban.id_ujian = tbujian.id_ujian))) WHERE (tbjawaban.id_ujian = ?)) hasil_ujian ON ((lap_peserta_ujian.id_mahasiswa = hasil_ujian.id_peserta))) where lap_peserta_ujian.id_ujian=? and lap_peserta_ujian.nobp=?",[id_ujian,id_ujian,nobp])
    }else{
        query = db.raw("SELECT lap_peserta_ujian.id_mahasiswa, lap_peserta_ujian.nobp, lap_peserta_ujian.nm_mahasiswa, CASE WHEN (hasil_ujian.nilai IS NOT NULL) THEN true ELSE false END AS status, hasil_ujian.id_tsoal FROM (lap_peserta_ujian LEFT JOIN ( SELECT tbhasil_ujian.id_hasil, tbhasil_ujian.id_ujian, tbhasil_ujian.id_peserta, tbhasil_ujian.nilai, tbujian.id_tsoal FROM (tbhasil_ujian JOIN tbujian ON ((tbhasil_ujian.id_ujian = tbujian.id_ujian))) WHERE (tbhasil_ujian.id_ujian = ?)) hasil_ujian ON ((lap_peserta_ujian.id_mahasiswa = hasil_ujian.id_peserta))) where lap_peserta_ujian.id_ujian=? and lap_peserta_ujian.nobp=?",[id_ujian,id_ujian,nobp])
    }
	query.then(function(rows){
		hasil.status = true;
		hasil.data = rows.rows;
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.json(hasil);
		});
	});
module.exports = router
