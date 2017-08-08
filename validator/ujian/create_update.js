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
	'jam': {
		notEmpty : {
			errorMessage : 'Jam harus harus diisi ...'
		}
	},
	'menit': {
		notEmpty : {
			errorMessage : 'Menit harus harus diisi ...'
		}
	}
};
module.exports = validasi;
