app.controller("kelolaPeserta", function($scope, $rootScope, $http, $location, $timeout){
	$scope.resetForm = function(){
		$scope.Tnm_peserta ='';
		$scope.ETnm_peserta ='';
		$scope.UTnm_peserta ='';
		$scope.EUTnm_peserta ='';
	};
	$scope.readData = function(x,y){
		var url;
		if(x == 0 && y == 0) url = $rootScope.serverBackEnd+'/api/peserta';
		else url = $rootScope.serverBackEnd+'/api/peserta?limit='+x+'&offset='+y;
		$rootScope.showLoading(true);
		$rootScope.pagination.limit = x;
		$rootScope.pagination.offset = y;
		$http.get(url)
		.then(function(res){
			$scope.data = res.data.data;
			$rootScope.pagNum(res.data.row,$rootScope.pagination.limit);
		})
		.catch(function(e){
			$rootScope.showPesan('Warning',e);
		})
		.finally(function(){
			$rootScope.showLoading(false);
		});
		};
	$scope.deleteData = function(id){
		$rootScope.showLoading(true);
		$http.delete($rootScope.serverBackEnd+'/api/peserta/'+id)
		.then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
				$rootScope.showPesan('Success','Data berhasil dihapus ...');
				$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
			}
			else {
				$rootScope.showPesan('Warning','Data gagal dihapus ...');
				$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
			}
		})
		.catch(function(e){
			$rootScope.showPesan('Warning'.e);
		})
		.finally(function(){
			$rootScope.bulkDelete = [];
			$rootScope.showLoading(false);
			$scope.toggleBulkdelete = false;
		});
		};
	$scope.createData = function(){
		var data = {
			nm_peserta : $scope.Tnm_peserta
		};
		data = JSON.stringify(data);
		$rootScope.tombolSimpan(1);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/peserta',
			data : data,
			contentType : 'application/json; charset=utf-8'
			})
			.then(function(res){
				var hasil = res.data;
				if(hasil.status == true){
					$scope.resetForm();
					$rootScope.showForm(0,0);
					$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
					$rootScope.showPesan('Success','Data berhasil ditambah ...');
				}
				else {
					$scope.ETnm_peserta = hasil.error.nm_peserta.msg;
				}
			})
			.catch(function(e){
				$rootScope.showForm(0,0);
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
				$rootScope.tombolSimpan(0);	
			})
		};
		$scope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/peserta/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.id = hasil.id_peserta;
				$scope.UTnm_peserta = hasil.nm_peserta;
				$rootScope.showForm(1,1);
			})
			.catch(function(e){
				$rootScope.showPesan('Warning',e);
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
				url : $rootScope.serverBackEnd+'/api/peserta/'+id,
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
						$scope.EUTnm_peserta = hasil.error.nm_peserta.msg;
						}
			})
			.catch(function(e){
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
				
			});
		}
$scope.readData($rootScope.pagination.limit,$rootScope.pagination.offset);
$scope.$watch('form',function(newValue,oldValue,scope){
	if(newValue == 'display:none;') scope.resetForm();
});
});
