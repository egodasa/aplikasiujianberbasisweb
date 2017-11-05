var validasi = {
	'nm_dosen': {
		notEmpty : {
			errorMessage : 'Nama dosen Soal harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 50}],
			errorMessage : 'Nama dosen Soal harus berisikan minimal 3 karakter dan maksimal 50 karakter ...'
		}
	},
	'nidn': {
		notEmpty : {
			errorMessage : 'NIDN harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 10}],
			errorMessage : 'NIDN harus berisikan minimal 1 karakter dan maksimal 50 karakter ...'
		}
	}
};
module.exports = validasi;
