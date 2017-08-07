var validasi = {
	'id_soal': {
		notEmpty : {
			errorMessage : 'Soal harus diisi ...'
		},
		isLength : {
			options : [{min : 7,max : 7}],
			errorMessage : 'Soal harus berisikan 7 karakter ...'
		}
	}
};
module.exports = validasi;
