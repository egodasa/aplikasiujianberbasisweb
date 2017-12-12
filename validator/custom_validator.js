var Promise = require('promise');
module.exports = {
		cekUsername : function(value){
			return new Promise(function(resolve, reject){
				var hasil;
				db('tbuser').select('username').where('username',value)
                .then((rows)=>{
                    if(rows.length > 0) resolve(false)
                    else resolve(true)
                    })
                .catch((err)=>{
                    resolve(false)
                    })
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
