app.controller("cekPesertaUjian", function($rootScope, $scope, $http, $location){
	$scope.pesanWarning = false;
	$scope.pesanSuccess = false;
	$scope.showSuccess = function(){
		$scope.pesanSuccess = !$scope.pesanSuccess;
	}
	$scope.showWarning = function(){
		$scope.pesanWarning = !$scope.pesanWarning;
	}
	$scope.getUjian = function(){
		$http.get($rootScope.serverBackEnd+'/api/ujian').then(function(res){
			$scope.listUjian = res.data.data;
		}), function(res){
			$scope.listUjian =[];
			};
		};
	
	$scope.cekPeserta = function(){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.idUjian.id_ujian+'/peserta/'+$scope.idPeserta).then(function(res){
				$scope.hasilCek = res.data.data;
				console.log($scope.hasilCek.length);
				if($scope.hasilCek.length <1) {
					$scope.showWarning();
				}
				else {
					$scope.showSuccess();
				}
		}), function(res){
				$scope.showWarning();
			};
		};
	
	$scope.getUjian();
});
