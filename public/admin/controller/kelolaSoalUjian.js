app.controller("kelolaSoalUjian", function($rootScope, $scope, $http, $location, $timeout, $routeParams){
	$scope.id_ujian = $routeParams.idUjian;
	$scope.createForm = false;
	$scope.showForm = function(x){
		if(x == 0) {
			$scope.form = "display:none;";
			}
		else{
			$scope.getSoal($scope.id_ujian);
			$scope.form = "display:block;";
		}
	}
	$scope.getSoal = function(id){
		$rootScope.showLoading(true);
		$http.get($rootScope.serverBackEnd+'/api/soal/not/'+id)
		.then(function(res){
			$scope.soal = res.data.data;
		})
		.catch(function(e){
			$rootScope.showPesan('Warning',e);
		})
		.finally(function(){
			$rootScope.showLoading(false);
		});
	};
	$scope.readData = function(){
		$rootScope.showLoading(true);
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal').then(function(res){
			$scope.data = res.data.data;
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
		data = JSON.stringify({id : id});
		$http.post($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal/delete',data)
		.then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
				console.log("data berhasil dihapus");
			$scope.readData();
			}
			else {
				console.log("data gagal dihapus");
				$scope.readData();
			}
		})
		.catch(function(e){
			$rootScope.showPesan('Warning',e);
		})
		.finally(function(){
		});
		};
	$scope.createData = function(id){
		var data = {
			id_soal : id
		};
		data = JSON.stringify(data);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			})
		.then(function(res){
				$scope.showForm(0,0);
				$scope.readData();
		})
		.catch(function(e){
			$scope.showForm(0,0);
			$rootScope.showPesan('Warning',e);
			})
		.finally(function(){
		});
	};
		$scope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal/'+id)
			.then(function(res){
				$scope.showUpdateForm();
			})
			.catch(function(e){
				$rootScope.showPesan('Warning',e);
			})
			.finally(function(){
			})
		}
if($scope.id_ujian == "") $location.path('/');
	else $scope.readData();
});
