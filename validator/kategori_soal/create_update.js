var validasi = {
	'Tnm_kategori': {
		notEmpty : {
			errorMessage : 'Kategori Soal harus diisi ...'
		},
		matches : {
			options : [/[a-zA-Z 0-9]{3,50}/i],
			errorMessage : "Kategori Soal minimal 3 karakter dan maksimal 30 karakter"
		},
		isLength : {
			options : [{min : 3,max : 30}],
			errorMessage : 'Kategori Soal harus berisikan minimal 3 karakter dan maksimal 30 karakter ...'
		}
	}
};
module.exports = validasi;
