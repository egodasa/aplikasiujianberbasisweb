app.controller("kelolaPesertaUjian", function($rootScope, $scope, $http, $location, ujian){
	$scope.id_ujian = ujian.getIdUjian();
	$scope.createForm = false;
	$scope.showForm = function(x){
		if(x == 0) {
			$scope.form = "display:none;";
			}
		else{
			$scope.getPeserta($scope.id_ujian);
			$scope.form = "display:block;";
		}
	}
	$scope.getPeserta = function(id){
		$http.get($rootScope.serverBackEnd+'/api/peserta/not/'+id).then(function(res){
			$scope.peserta = res.data.data;
		}), function(res){
			$scope.peserta =[];
			};
	};
	$scope.readData = function(){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/peserta').then(function(res){
			$scope.data = res.data.data;
		}), function(res){
			$scope.data =[];
			};
		};
	$scope.deleteData = function(id){
		$http.post($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/peserta/delete',JSON.stringify({id_peserta_ujian : id})).then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
				console.log("data berhasil dihapus");
			$scope.readData();
			}
			else {
				console.log("data gagal dihapus");
				$scope.readData();
			}
		}), function(res){
			console.log(res.data.status);
			};
		};
	$scope.createData = function(id){
		var data = {
			id_peserta : id
		};
		data = JSON.stringify(data);
		console.log(data);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/peserta/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			}).then(function(res){
				$scope.showForm(0);
				$scope.readData();
		}), function(res){
			console.log(res.data.status);
			};
		};
		$scope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/peserta/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.id = hasil.id_ujian;
				$scope.UTnm_ujian = hasil.nm_ujian;
				$scope.showUpdateForm();
			}), function(res){
				console.log('error fetch data details');
			};
		}
if($scope.id_ujian == "") $location.path('/');
	else $scope.readData();
});
