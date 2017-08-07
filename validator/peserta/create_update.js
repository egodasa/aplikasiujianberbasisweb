var validasi = {
	'nm_peserta': {
		notEmpty : {
			errorMessage : 'Nama peserta harus diisi ...'
		},
		isLength : {
			options : [{min : 3,max : 50}],
			errorMessage : 'Nama peserta harus berisikan minimal 3 karakter dan maksimal 50 karakter ...'
		}
	}
};
module.exports = validasi;
