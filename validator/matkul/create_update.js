var validasi = {
	'nm_matkul': {
		notEmpty : {
			errorMessage : 'Nama matkul harus diisi ...'
		},
		isLength : {
			options : [{min : 2,max : 30}],
			errorMessage : 'Nama matkul harus berisikan minimal 2 karakter dan maksimal 30 karakter ...'
		}
	},
	'sks': {
		notEmpty : {
			errorMessage : 'SKS harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 10}],
			errorMessage : 'SKS tidak benar ...'
		}
	}
};
module.exports = validasi;

