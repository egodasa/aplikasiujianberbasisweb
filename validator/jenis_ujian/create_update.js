var validasi = {
	'nm_jujian': {
		notEmpty : {
			errorMessage : 'Nama jenis Soal harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 10}],
			errorMessage : 'Nama jenis Soal harus berisikan minimal 3 karakter dan maksimal 20 karakter ...'
		}
	}
};
module.exports = validasi;
