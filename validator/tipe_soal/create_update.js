var validasi = {
	'nm_tipe': {
		notEmpty : {
			errorMessage : 'Nama Tipe Soal harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 15}],
			errorMessage : 'Nama Tipe Soal harus berisikan minimal 3 karakter dan maksimal 20 karakter ...'
		}
	}
};
module.exports = validasi;
