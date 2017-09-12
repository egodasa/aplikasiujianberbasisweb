app.controller("kelolaUjian", function($rootScope, $scope, $http, $location, $timeout){
	$rootScope.showLoading = function(x){
		if(x == true) $rootScope.loading = 'display:block;';
		else $rootScope.loading = 'display:none;';
	};
	$scope.setIdUjian = function(x,y){
		ujian.setIdUjian(x,y);
	};
	$scope.resetForm = function(x){
		if(x == 0){
			$scope.Tnm_ujian = '';
			$scope.ETnm_ujian = '';
			$scope.Tjam = '';
			$scope.ETjam = '';
			$scope.Tmenit = '';
			$scope.ETmenit = '';
		}
		else {
			$scope.EUTnm_ujian = '';
			$scope.UTnm_ujian = '';
			$scope.EUTjam = '';
			$scope.UTjam = '';
			$scope.EUTmenit = '';
			$scope.UTmenit = '';
		}
	};
	$scope.readData = function(x,y){
		var url;
		if(x == 0 && y == 0) url = $rootScope.serverBackEnd+'/api/ujian';
		else url = $rootScope.serverBackEnd+'/api/ujian?limit='+x+'&offset='+y;
		$rootScope.showLoading(true);
		$rootScope.pagination.limit = x;
		$rootScope.pagination.offset = y;
		$rootScope.showLoading(true);
		$http.get(url)
		.then(function(res){
			$scope.data = res.data.data;
			$rootScope.pagNum(res.data.row,$rootScope.pagination.limit);
		}).catch(function(e){
			$rootScope.showPesan('Warning',e);
		}).finally(function(){
			$rootScope.showLoading(false);
		});
	};
	$scope.deleteData = function(id){
		$rootScope.showLoading(true);
		$http({
		method : 'DELETE',
		url : $rootScope.serverBackEnd+'/api/ujian/'+id
		})
		.then(function(res){
			var result = res.data.status;
			console.log(result);
			console.log(res.data);
			if(result == true){
				$rootScope.showPesan('Success','Data berhasil di<b>Hapus</b> ...');
				$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
			}
			else {
				var result = res.data;
				$rootScope.showPesan('Warning','Telah terjadi kesalahan. <br/> Pesan error : '+res.data.error);
			}
		})
		.catch(function(e){
			$rootScope.showPesan('Warning',e);
		})
		.finally(function(){
			$rootScope.bulkDelete = [];
			$rootScope.showLoading(false);
		});
	};
	$scope.createData = function(){
		var data = {
			nm_ujian : $scope.Tnm_ujian,
			jam : $scope.Tjam,
			menit : $scope.Tmenit
		};
		data = JSON.stringify(data);
		$rootScope.tombolSimpan(1);
		$http({
		method : 'POST',
		url : $rootScope.serverBackEnd+'/api/ujian',
		data : data,
		contentType : 'application/json; charset=utf-8'
		})
		.then(function(res){
		var hasil = res.data;
		if(hasil.status == true){
			$scope.resetForm();
			$rootScope.showForm(0,0);
			$rootScope.showPesan('Success','Data baru berhasil ditambahkan ...');
			$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
		}
		else {
			$scope.ETnm_ujian = hasil.error.nm_ujian.msg;
			$scope.ETjam = hasil.error.jam.msg;
			$scope.ETmenit = hasil.error.menit.msg;
		}
		})
		.catch(function(e){
			$rootScope.showPesan('Warning',e);
		})
		.finally(function(){
			$rootScope.tombolSimpan(0);
		});
		};
		$scope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.id = hasil.id_ujian;
				$scope.UTnm_ujian = hasil.nm_ujian;
				$scope.UTjam = hasil.jam;
				$scope.UTmenit = hasil.menit;
				$rootScope.showForm(1,1);
			}).catch(function(e){
				$rootScope.showPesan('Warning','Telah terjadi kesalahan. <br/> Pesan error : '+e);
			}).finally(function(){
				});
		}
		$scope.updateData = function(id){
			var data = {
				nm_ujian : $scope.UTnm_ujian,
				jam : $scope.UTjam,
				menit : $scope.UTmenit
			};
			data = JSON.stringify(data);
			$http({
				method : 'PUT',
				url : $rootScope.serverBackEnd+'/api/ujian/'+id,
				data : data,
				contentType : 'application/json; charset=utf-8'
			})
			.then(function(res){
				var hasil = res.data;
					if(hasil.status == true){
						$scope.resetForm();
						$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
						$rootScope.showForm(0,1);
						$rootScope.showPesan('Success','Perubahan disimpan ...');
						}
					else {
						$scope.EUTnm_ujian = hasil.error.nm_ujian.msg;
						$scope.EUTjam = hasil.error.jam.msg;
						$scope.EUTmenit = hasil.error.menit.msg;
						}
				})
			.catch(function(e){
				$rootScope.showForm(0,1);
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
				
			})
		}
$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
$scope.$watch('form',function(newValue,oldValue,scope){
	if(newValue == 'display:none;') scope.resetForm();
});
});
