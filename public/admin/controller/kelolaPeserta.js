app.controller("kelolaPeserta", function($rootScope, $rootScope, $http, $location, $timeout){
	$rootScope.resetForm = function(){
		$rootScope.Tnm_peserta ='';
		$rootScope.ETnm_peserta ='';
		$rootScope.UTnm_peserta ='';
		$rootScope.EUTnm_peserta ='';
	};
	$rootScope.readData = function(x,y){
		var url;
		if(x == 0 && y == 0) url = $rootScope.serverBackEnd+'/api/peserta';
		else url = $rootScope.serverBackEnd+'/api/peserta/limit/'+x+'/offset/'+y;
		$rootScope.showLoading(true);
		$rootScope.pagination.limit = x;
		$rootScope.pagination.offset = y;
		$http.get(url)
		.then(function(res){
			$rootScope.data = res.data.data;
			$rootScope.pagNum(res.data.row,$rootScope.pagination.limit);
		})
		.catch(function(e){
			$rootScope.showPesan('Warning',e);
		})
		.finally(function(){
			$rootScope.showLoading(false);
		});
		};
	$rootScope.deleteData = function(id){
		$rootScope.showLoading(true);
		$http.delete($rootScope.serverBackEnd+'/api/peserta/delete/'+id)
		.then(function(res){
			$rootScope.result = res.data.status;
			if($rootScope.result == true){
				$rootScope.showPesan('Success','Data berhasil dihapus ...');
				$rootScope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
			}
			else {
				$rootScope.showPesan('Warning','Data gagal dihapus ...');
				$rootScope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
			}
		})
		.catch(function(e){
			$rootScope.showPesan('Warning'.e);
		})
		.finally(function(){
			$rootScope.showLoading(false);
		});
		};
	$rootScope.createData = function(){
		var data = {
			nm_peserta : $rootScope.Tnm_peserta
		};
		data = JSON.stringify(data);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/peserta/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			})
			.then(function(res){
				var hasil = res.data;
				if(hasil.status == true){
					$rootScope.resetForm($rootScope.pagination.limit,$rootScope.pagination.offset);
					$rootScope.showForm(0,0);
					$rootScope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
					$rootScope.showPesan('Success','Data berhasil ditambah ...');
				}
				else {
					$rootScope.ETnm_peserta = hasil.error.nm_peserta.msg;
				}
			})
			.catch(function(e){
				$rootScope.showForm(0,0);
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
				
			})
		};
		$rootScope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/peserta/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$rootScope.id = hasil.id_peserta;
				$rootScope.UTnm_peserta = hasil.nm_peserta;
				$rootScope.showForm(1,1);
			})
			.catch(function(e){
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
				
			})
		}
		$rootScope.updateData = function(id){
			var data = {
				nm_peserta : $rootScope.UTnm_peserta
			};
			data = JSON.stringify(data);
			$http({
				method : 'PUT',
				url : $rootScope.serverBackEnd+'/api/peserta/update/'+id,
				data : data,
				contentType : 'application/json; charset=utf-8'
			})
			.then(function(res){
				var hasil = res.data;
					if(hasil.status == true){
						$rootScope.resetForm();
						$rootScope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
						$rootScope.showForm(0,1);
						$rootScope.showPesan('Success','Perubahan disimpan ...');
						}
					else {
						$rootScope.EUTnm_peserta = hasil.error.nm_peserta.msg;
						}
			})
			.catch(function(e){
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
				
			});
		}
$rootScope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
$rootScope.$watch('form',function(newValue,oldValue,scope){
	if(newValue == 'display:none;') scope.resetForm();
});
});
