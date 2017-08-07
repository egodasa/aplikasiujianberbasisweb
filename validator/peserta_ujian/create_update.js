var validasi = {
	'id_peserta': {
		notEmpty : {
			errorMessage : 'ID Peserta tidak valid ...'
		},
		isLength : {
			options : [{min : 1,max : 11}],
			errorMessage : 'Nama peserta harus berisikan minimal 1 karakter dan maksimal 1 karakter ...'
		}
	}
};
module.exports = validasi;
