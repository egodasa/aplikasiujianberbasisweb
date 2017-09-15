var express = require('express');
var router = express.Router();
var checkData = require('../validator/ujian/create_update');
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
var checkDataSoal = require('../validator/soal/create_update');

router.get('/:id?', (req, res, next) => {
	var id = req.params.id || "0000000";
	var limit = req.query.limit || 0;
	var offset = req.query.offset || 0;
    sql = 'call getUjian(?,?,?);';
    koneksi.query(sql,[id,limit,offset], (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.data = r[0];
        hasil.row = r[1][0].jumlah;
        hasil.error = e;
        res.json(hasil);
    });
});
router.post('/', (req, res, next) => {
    var data = req.body;
    var hasil = {};
    req.checkBody(checkData);
    req.getValidationResult().then(function(result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            hasil.status = false;
            hasil.error = pesan;
            res.json(hasil);
        } else {
            sql = 'call createUjian(?,?,?);';
            koneksi.query(sql,[data.nm_ujian,data.jam,data.menit], function(e, r, f) {
                if (!e) hasil.status = true;
                else hasil.status = false;
                hasil.error = e;
                res.json(hasil);
            });
        }
    });
});
router.delete('/:id', (req, res, next) => {
    var id = req.params.id;
    var hasil = {};
    sql = 'call deleteUjian(?);';
    koneksi.query(sql,[id], (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.error = e;
        res.json(hasil);
    });
});
router.put('/:id', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
    req.checkBody(checkData);
    req.getValidationResult().then(function(result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            if (pesan.nm_ujian == undefined) {
                pesan.nm_ujian = {
                    param: "nm_ujian",
                    msg: "",
                    value: data.nm_ujian
                };
            }
            if (pesan.jam == undefined) {
                pesan.jam = {
                    param: "jam",
                    msg: "",
                    value: data.jam
                };
            }
            if (pesan.menit == undefined) {
                pesan.menit = {
                    param: "menit",
                    msg: "",
                    value: data.menit
                };
            }
            hasil.status = false;
            hasil.error = pesan;
            res.json(hasil);
        } else {
            sql = 'call updateUjian(?,?,?,?);';
            koneksi.query(sql,[id,data.nm_ujian,data.jam,data.menit], function(e, r, f) {
                if (!e) hasil.status = true;
                else hasil.status = false;
                hasil.error = e;
                res.json(hasil);
            });
        }
    });
});

//Peserta Ujian
var checkDataPeserta = require('../validator/peserta_ujian/create_update');
router.get('/:id/peserta/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var idPeserta = req.params.idPeserta || 0;
    var limit = req.query.limit || 0;
    var offset = req.query.offset || 0;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
    if(belumDitambahkan == 0){
		sql = 'call getPesertaUjian(?,?,?,?);';
		sqlParam = [id,idPeserta,limit,offset];
	}else{
		sql = 'call getNotPesertaUjian(?,?,?);';
		sqlParam = [id,limit,offset];
	}
    koneksi.query(sql,sqlParam, (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.data = r[0];
        hasil.row = r[1][0].jumlah;
        hasil.error = e;
        res.json(hasil);
    });
});
router.post('/:id/peserta/', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    var hasil = {};
    req.checkBody(checkDataPeserta);
    req.getValidationResult().then(function(result) {
        result.useFirstErrorOnly();
        var pesan = result.mapped();
        if (result.isEmpty() == false) {
            if (pesan.id_peserta == undefined) {
                pesan.id_peserta = {
                    param: "id_peserta",
                    msg: "",
                    value: data.id_peserta
                };
            }
            hasil = {
                status: false,
                error: pesan
            };
            res.json(hasil);
        } else {
            sql = 'call createPesertaUjian(?,?);';
            console.log(sql);
            koneksi.query(sql,[id,data.id_peserta], function(e, r, f) {
                var hasil = {};
                if (!e) hasil.status = true;
                else hasil.status = false;
                hasil.error = e;
                res.json(hasil);
            });
        }
    });
});
router.delete('/:id/peserta/:id_pu', (req, res, next) => {
    var id = req.params.id;
    var id_pu = req.params.id_pu;
    var id_peserta_ujian = req.body.id_peserta_ujian;
    console.log(id_peserta_ujian);
    var hasil = {};
    sql = 'call deletePesertaUjian(?);';
    koneksi.query(sql,[id_pu], (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.error = e;
        res.json(hasil);
    });
});

//Soal Ujian

router.get('/:id/soal', (req, res, next) => {
    var id = req.params.id;
    var limit = req.query.limit || 0;
    var offset = req.query.offset || 0;
    var belumDitambahkan = req.query.belumDitambahkan || 0;
	sql = 'call getSoalUjian(?,?,?);';
	sqlParam = [id,limit,offset];
    koneksi.query(sql,sqlParam, (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        console.log(r);
        hasil.data = r[0];
        hasil.row = r[1][0].jumlah;
        hasil.error = e;
        res.json(hasil);
    });
});
router.post('/:id/soal/', (req, res, next) => {
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
	console.log(data);
	req.checkBody(checkDataSoal);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		if(pesan.isi_soal == undefined){
			pesan.isi_soal ={
				param : "isi_soal",
				msg : "",
				value : data.isi_soal
			};
		}
		if(pesan.jawaban == undefined){
			pesan.jawaban ={
				param : "jawaban",
				msg : "",
				value : data.jawaban
			};
		}
		hasil.status = false;
		hasil.error = pesan;
	console.log(hasil);
	res.json(hasil); 
	}
	else{
	var sql1 = '';
	var pg = data.pilihanGanda;
	for(var x=0;x<pg.length;x++){
		if(x == 0) sql1 = '(@id_pg,"'+pg[x].huruf+'","'+pg[x].isi_pilihan+'")';
		else sql1+= ',(@id_pg,"'+pg[x].huruf+'","'+pg[x].isi_pilihan+'")';
	}
	sql = 'set @id_pg=genIdSoal(); call createSoal(@id_pg,?,?); insert into tbpilihan_ganda (id_soal,huruf,isi_pilihan) values '+sql1+'; call createSoalUjian(?,@id_pg);';
	koneksi.query(sql,[data.isi_soal,data.jawaban,id], function(e, r, f){
		if(!e) hasil.status = true;
		else hasil.status = false;
		hasil.error = e;
		console.log(hasil);
		res.json(hasil);
		});
	}
});
});
router.delete('/:id/soal/:idSoal', (req, res, next) => {
    var id = req.params.id;
    var idSoal = req.params.idSoal;
    var data = req.body;
    var hasil = {};
    sql = 'call deleteSoalUjian(?);';
    koneksi.query(sql,[idSoal], (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.error = e;
        res.json(hasil);
    });
});

//HASIL UJIAN
router.get('/:id/hasil/:idPeserta?', (req, res, next) => {
    var id = req.params.id;
    var id = req.params.idPeserta || 0;
    var limit = req.query.limit || 0;
    var offset = req.query.offset || 0;
    sql = 'call getHasilUjian(?,?,?,?);';
    koneksi.query(sql,[id,idPeserta,limit,offset], (e, r, f) => {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.data = r[0];
        hasil.row = r[1][0].jumlah;
        hasil.error = e;
        res.json(hasil);
    });
});
router.post('/:id/hasil', (req, res, next) => {
    var data = req.body;
    var id = req.params.id;
    sql = 'call createHasilUjian(?,?,?,?);';
    console.log(sql);
    koneksi.query(sql,[id,data.id_peserta,data.benar,data.salah], function(e, r, f) {
        var hasil = {};
        if (!e) hasil.status = true;
        else hasil.status = false;
        hasil.error = e;
        res.json(hasil);
    });
});
module.exports = router;
