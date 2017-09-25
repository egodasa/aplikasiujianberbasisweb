var validasi = {
	'nm_ujian': {
		notEmpty : {
			errorMessage : 'Nama ujian harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 30}],
			errorMessage : 'Nama ujian harus berisikan minimal 1 karakter dan maksimal 30 karakter ...'
		}
	},
	'durasi_ujian': {
		notEmpty : {
			errorMessage : 'Durasi ujian harus diisi ...'
		}
	}
};
module.exports = validasi;
