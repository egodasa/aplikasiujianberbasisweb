app.controller("kelolaSoalUjian", function($rootScope, $scope, $http, $location, ujian){
	$scope.id_ujian = ujian.getIdUjian();
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
		$http.get($rootScope.serverBackEnd+'/api/soal/not/'+id).then(function(res){
			$scope.soal = res.data.data;
		}), function(res){
			$scope.soal =[];
			};
	};
	$scope.readData = function(){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal').then(function(res){
			$scope.data = res.data.data;
		}), function(res){
			$scope.data =[];
			};
		};
	$scope.deleteData = function(id){
		data = JSON.stringify({id : id});
		$http.post($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal/delete',data).then(function(res){
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
			id_soal : id
		};
		data = JSON.stringify(data);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			}).then(function(res){
				$scope.showForm(0,0);
				$scope.readData();
		}), function(res){
			console.log(res.data.status);
			};
		};
		$scope.detailData = function(id){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.id_ujian+'/soal/'+id)
			.then(function(res){
				$scope.showUpdateForm();
			}), function(res){
				console.log('error fetch data details');
			};
		}
if($scope.id_ujian == "") $location.path('/');
	else $scope.readData();
});
