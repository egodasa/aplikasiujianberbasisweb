<h1>Aplikasi ujian berbasis web</h1>
*versi : 1.0.0*

<h2>Keterangan</h2>
1. Backend menggunakan NodeJS dan frontend menggunakan angularjs v1.6.5 
2. Pertukaran data menggunakan konsep Restful API dengan format data JSON.

<h2>Fitur</h2>
1. CRUD peserta,soal,ujian,soal ujian dan peserta ujian
2. Pelaksanaan ujian belum sempurna
3. support validasi data pada CRUD kecuali CRUD soal.
4. Laporan hasil ujian setelah selesai pelaksanaan ujian oleh peserta.

<h2>Kekurangan</h2>
1. Pelaksanaan ujian masih belum menggunakan waktu atau timer.
2. Belum menerapkan session atau cookies sehingga jika direfresh pada pelaksanaan ujian maka semua akan tereset.
3. Belum ada laporan hasil ujian seluruh peserta untuk admin.
4. Pada frontend (AngularJS) masih menerapkan module $http native untuk pertukaran data. DI versi selanjutnya akan 
menggunakan modul $resource.

<h2>Informasi</h2>
1. Untuk module yang dibutuhkan NodeJS silahkan lihat file "package.json".
2. File untuk frontend AngularJS dapat dilihat pada folder "public". Untuk halaman admin pada folder "admin" dan folder 
"peserta" untuk halaman peserta ujian.

URL admin : [localhost:3000/admin](localhost:3000/admin)
URL peserta : [localhost:3000/peserta](localhost:3000/peserta)
URL API : [localhost:3000/api/NAMA_DATA](localhost:3000/api/NAMA_DATA)
File Database : dbujian.sql
