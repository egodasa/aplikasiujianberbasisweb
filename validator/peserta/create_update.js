var validasi = {
	'nm_mahasiswa': {
		notEmpty : {
			errorMessage : 'Nama mahasiswa harus diisi ...'
		},
		isLength : {
			options : [{min : 3,max : 50}],
			errorMessage : 'Nama mahasiswa harus berisikan minimal 3 karakter dan maksimal 50 karakter ...'
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
	},
	'id_kelas': {
		notEmpty : {
			errorMessage : 'Kelas harus diisi ...'
		}
	}
    
};
module.exports = validasi;
