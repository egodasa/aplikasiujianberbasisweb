var Promise = require('promise');
module.exports = {
		cekUsername : function(value){
			return new Promise(function(resolve, reject){
				var hasil;
				sql = 'SELECT COUNT(username) as "username" from tbpengguna WHERE username='+mysql.escape(value)+';';
				koneksi.query(sql, function(e, rows, f){
					if(rows[0].username == 0) {
						hasil = true;
						resolve(hasil);
						}
					else{
						hasil = false;
						reject(hasil);
						} 
					});	
			})
		},		
		cekNohp : function(value){
			return new Promise(function(resolve, reject){
				var hasil;
				sql = 'SELECT COUNT(nohp) as "nohp" from tbpengguna WHERE nohp='+mysql.escape(value)+';';
				koneksi.query(sql, function(e, rows, f){
					if(rows[0].nohp == 0) {
						hasil = true;
						resolve(hasil);
						}
					else{
						hasil = false;
						reject(hasil);
						} 
					});	
			})
		},		
};
