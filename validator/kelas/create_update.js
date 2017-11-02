var validasi = {
	'nm_kelas': {
		notEmpty : {
			errorMessage : 'Nama kelas harus diisi ...'
		},
		isLength : {
			options : [{min : 3,max : 50}],
			errorMessage : 'Nama kelas harus berisikan minimal 3 karakter dan maksimal 50 karakter ...'
		}
	}
};
module.exports = validasi;
