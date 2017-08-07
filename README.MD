APlikasi ujian berbasis web
versi : 1.0.0

Keterangan :
-Backend menggunakan NodeJS dan frontend menggunakan angularjs v1.6.5
-Pertukaran data menggunakan konsep Restful API dengan format data JSON.

Fitur :
-CRUD peserta,soal,ujian,soal ujian dan peserta ujian
-Pelaksanaan ujian belum sempurna
-support validasi data pada CRUD kecuali CRUD soal.
-Laporan hasil ujian setelah selesai pelaksanaan ujian oleh peserta.

Kekurangan :
-Pelaksanaan ujian masih belum menggunakan waktu atau timer.
-Belum menerapkan session atau cookies sehingga jika direfresh pada pelaksanaan ujian maka semua akan tereset.
-Belum ada laporan hasil ujian seluruh peserta untuk admin.
-Pada frontend (AngularJS) masih menerapkan module $http native untuk pertukaran data. DI versi selanjutnya akan menggunakan modul $resource.

Informasi :
-Untuk module yang dibutuhkan NodeJS silahkan lihat file "package.json".
-File untuk frontend AngularJS dapat dilihat pada folder "public". Untuk halaman admin pada folder "admin" dan folder "peserta" untuk halaman peserta ujian.

URL admin : localhost:3000/admin
URL peserta : localhost:3000/peserta
URL API : localhost:3000/api/NAMA_DATA
File Database : dbujian.sql
