var validasi = {
	'nm_mahasiswa': {
		notEmpty : {
			errorMessage : 'Nama mahasiswa harus diisi ...'
		},
		isLength : {
			options : [{min : 2,max : 100}],
			errorMessage : 'Nama mahasiswa harus berisikan minimal 2 karakter dan maksimal 100 karakter ...'
		}
	},
	'nobp': {
		notEmpty : {
			errorMessage : 'NOBP harus diisi ...'
		},
		isLength : {
			options : [{min : 14,max : 14}],
			errorMessage : 'NOBP tidak benar ...'
		}
	}
    
};
module.exports = validasi;

