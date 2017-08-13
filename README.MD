<h1>Aplikasi ujian berbasis web</h1>
versi : 1.0.0

<h2>Keterangan</h2>
1. Backend menggunakan NodeJS dan frontend menggunakan angularjs v1.6.5 
2. Pertukaran data menggunakan konsep Restful API dengan format data JSON.

<h2>Fitur</h2>
1. CRUD peserta,soal,ujian,soal ujian dan peserta ujian
2. Pelaksanaan ujian belum sempurna
3. support validasi data pada CRUD kecuali CRUD soal.
4. Laporan hasil ujian setelah selesai pelaksanaan ujian oleh peserta.

<h2>Kekurangan</h2>
1. Pada frontend (AngularJS) masih menerapkan module $http native untuk pertukaran data. DI versi selanjutnya akan 
menggunakan modul $resource.
2. Masih menggunakan cookies untuk mengingat sesi ujian. Akan digantikan dengan localStorage
<h2>Informasi</h2>
1. Untuk module yang dibutuhkan NodeJS silahkan lihat file "package.json".
2. File untuk frontend AngularJS dapat dilihat pada folder "public". Untuk halaman admin pada folder "admin" dan folder 
"peserta" untuk halaman peserta ujian.

Versi Admin : [https://ujianweb.herokuapp.com/admin](https://ujianweb.herokuapp.com/admin)
Versi Peserta : [https://ujianweb.herokuapp.com/peserta](https://ujianweb.herokuapp.com/peserta)

URL admin : [localhost:3000/admin](localhost:3000/admin)
URL peserta : [localhost:3000/peserta](localhost:3000/peserta)
URL API : [localhost:3000/api/NAMA_DATA](localhost:3000/api/NAMA_DATA)
File Database : dbujian.sql
