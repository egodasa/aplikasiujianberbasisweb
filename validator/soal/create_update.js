var validasi = {
	'isi_soal': {
		notEmpty : {
			errorMessage : 'Soal harus diisi ...'
		},
		isLength : {
			options : [{min : 3,max : 1000}],
			errorMessage : 'Soal harus berisikan minimal 3 karakter dan maksimal 1000 karakter ...'
		}
	},
	'jawaban' :{
		notEmpty : {
			errorMessage : 'Jawaban harus dipilih ...'
		}
	}
};
module.exports = validasi;
