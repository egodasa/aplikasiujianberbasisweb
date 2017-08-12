app.controller("kelolaPeserta", function($rootScope, $scope, $http, $location){
	$scope.showLoading = function(x){
		if(x == true) $rootScope.loading = 'display:block;';
		else $rootScope.loading = 'display:none;';
	};
	$scope.showLoading(false);
	$scope.pesan = false;
	$scope.showPesan= function(tipe,isi){
		if(tipe == 'Warning') $scope.tipePesan = 'w3-panel w3-red';
		else $scope.tipePesan = 'w3-panel w3-green';
		$scope.isiPesan = isi;
		$scope.pesan = true;
	};
	$scope.closePesan = function(){
		$scope.pesan = false;
		$scope.isiPesan = '';
	};
	$scope.resetForm = function(){
		$scope.Tnm_peserta ='';
		$scope.ETnm_peserta ='';
		$scope.UTnm_peserta ='';
		$scope.EUTnm_peserta ='';
	};
	$scope.createForm = false;
	$scope.updateForm = false;
	$scope.showForm = function(x,y){
		if(x == 0) {
			$scope.form = "display:none;";
			$scope.resetForm();
			}
		else $scope.form = "display:block;";
		
		if(y == 0){
			$scope.createForm = true;
			$scope.updateForm = !$scope.createForm;
		}
		else{
			$scope.updateForm = true;
			$scope.createForm = !$scope.updateForm;
		}
	}
	$scope.readData = function(){
		$scope.showLoading(true);
		$http.get($rootScope.serverBackEnd+'/api/peserta')
		.then(function(res){
			$scope.data = res.data.data;
		})
		.catch(function(e){
			$scope.showPesan('Warning',e);
		})
		.finally(function(){
			$scope.showLoading(false);
		});
		};
	$scope.deleteData = function(id){
		$scope.showLoading(true);
		$http.delete($rootScope.serverBackEnd+'/api/peserta/delete/'+id)
		.then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
				$scope.showPesan('Success','Data berhasil dihapus ...');
				$scope.readData();
			}
			else {
				$scope.showPesan('Warning','Data gagal dihapus ...');
				$scope.readData();
			}
		})
		.catch(function(e){
			$scope.showPesan('Warning'.e);
		})
		.finally(function(){
			$scope.showLoading(false);
		});
		};
	$scope.createData = function(){
		var data = {
			nm_peserta : $scope.Tnm_peserta
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
					$scope.resetForm();
					$scope.showForm(0,0);
					$scope.readData();
					$scope.showPesan('Success','Data berhasil ditambah ...');
				}
				else {
					$scope.ETnm_peserta = hasil.error.nm_peserta.msg;
				}
			})
			.catch(function(e){
				$scope.showForm(0,0);
				$scope.showPesan('Warning',e);
			})
			.finally(function(){
				
			})
		};
		$scope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/peserta/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.id = hasil.id_peserta;
				$scope.UTnm_peserta = hasil.nm_peserta;
				$scope.showForm(1,1);
			})
			.catch(function(e){
				$scope.showPesan('Warning',e);
			})
			.finally(function(){
				
			})
		}
		$scope.updateData = function(id){
			var data = {
				nm_peserta : $scope.UTnm_peserta
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
						$scope.resetForm();
						$scope.readData();
						$scope.showForm(0,1);
						$scope.showPesan('Success','Perubahan disimpan ...');
						}
					else {
						$scope.EUTnm_peserta = hasil.error.nm_peserta.msg;
						}
			})
			.catch(function(e){
				$scope.showPesan('Warning',e);
			})
			.finally(function(){
				
			});
		}
$scope.readData();
});
