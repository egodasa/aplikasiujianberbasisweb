app.controller("cekPesertaUjian", function($scope, $http, $location, infoPesertaUjian){
	$scope.setPesertaUjian = function(x,y){
		infoPesertaUjian.setPesertaUjian(x,y);
	};
	$scope.setNoKerja = function(x){
		infoPesertaUjian.setNoKerja(x);
	};
	$scope.pesanWarning = false;
	$scope.pesanSuccess = false;
	$scope.showSuccess = function(){
		$scope.pesanSuccess = !$scope.pesanSuccess;
	}
	$scope.showWarning = function(){
		$scope.pesanWarning = !$scope.pesanWarning;
	}
	$scope.setSoalUjian = function(x){
		infoPesertaUjian.setSoalUjian(x);
	};
	$scope.getUjian = function(){
		$http.get('http://localhost:3000/api/ujian').then(function(res){
			$scope.listUjian = res.data.data;
		}), function(res){
			$scope.listUjian =[];
			};
		};
	$scope.cekPeserta = function(){
		$http.get('http://localhost:3000/api/ujian/'+$scope.idUjian.id_ujian+'/peserta/'+$scope.idPeserta).then(function(res){
				$scope.hasilCek = res.data.data;
				if($scope.hasilCek.length <1) {
					$scope.showWarning();
				}
				else {
					$scope.setPesertaUjian($scope.idUjian,$scope.idPeserta);
					$scope.setSoalUjian($scope.idUjian);
					$location.path('/petunjuk');
				}
		}), function(res){
				$scope.showWarning();
			};
		};
	$scope.getUjian();
});
