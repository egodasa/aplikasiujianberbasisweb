app.controller("kelolaPeserta", function($rootScope, $scope, $http, $location, $timeout){
	$scope.pagination = {
		limit : 10,
		offset : 0
	};
	$scope.pagNum = function(length,limit){
		var hasil = Math.ceil(length/limit);
		$scope.pagCount=[];
		for(x = 0;x < hasil;x++){
			$scope.pagCount.push(x);
		}
		console.log($scope.pagCount);
	};
	$scope.resetForm = function(){
		$scope.Tnm_peserta ='';
		$scope.ETnm_peserta ='';
		$scope.UTnm_peserta ='';
		$scope.EUTnm_peserta ='';
	};
	$scope.readData = function(x,y){
		var url;
		if(x == 0 && y == 0) url = $rootScope.serverBackEnd+'/api/peserta';
		else url = $rootScope.serverBackEnd+'/api/peserta/limit/'+x+'/offset/'+y;
		$rootScope.showLoading(true);
		$scope.pagination.limit = x;
		$scope.pagination.offset = y;
		$http.get(url)
		.then(function(res){
			$scope.data = res.data.data;
			$scope.pagNum(res.data.row,$scope.pagination.limit);
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
		$http.delete($rootScope.serverBackEnd+'/api/peserta/delete/'+id)
		.then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
				$rootScope.showPesan('Success','Data berhasil dihapus ...');
				$scope.readData($scope.pagination.limit,$scope.pagination.offset);
			}
			else {
				$rootScope.showPesan('Warning','Data gagal dihapus ...');
				$scope.readData($scope.pagination.limit,$scope.pagination.offset);
			}
		})
		.catch(function(e){
			$rootScope.showPesan('Warning'.e);
		})
		.finally(function(){
			$rootScope.showLoading(false);
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
					$scope.resetForm($scope.pagination.limit,$scope.pagination.offset);
					$rootScope.showForm(0,0);
					$scope.readData($scope.pagination.limit,$scope.pagination.offset);
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
				url : $rootScope.serverBackEnd+'/api/peserta/update/'+id,
				data : data,
				contentType : 'application/json; charset=utf-8'
			})
			.then(function(res){
				var hasil = res.data;
					if(hasil.status == true){
						$scope.resetForm();
						$scope.readData($scope.pagination.limit,$scope.pagination.offset);
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
$scope.readData($scope.pagination.limit,$scope.pagination.offset);

$scope.$watch('form',function(newValue,oldValue,scope){
	if(newValue == 'display:none;') scope.resetForm();
});
});
