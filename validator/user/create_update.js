var validasi = {
	'username': {
		notEmpty : {
			errorMessage : 'Username harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 15}],
			errorMessage : 'Username harus berisikan minimal 3 karakter dan maksimal 15 karakter ...'
		}
	},
	'password': {
		notEmpty : {
			errorMessage : 'Password harus diisi ...'
		},
		isLength : {
			options : [{min : 1,max : 255}],
			errorMessage : 'Password harus berisikan minimal 1 karakter dan maksimal 50 karakter ...'
		}
	}
};
module.exports = validasi;
