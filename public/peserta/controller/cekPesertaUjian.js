app.controller("cekPesertaUjian", function($scope, $http, $location, $cookies, infoPesertaUjian, sesiUjian){
	$scope.setSesiUjian = function(x,y,z,a,b){
		sesiUjian.setSesiUjian(x,y,z,a,b);
	};
	$scope.setSesiLjk = function(x,y){
		sesiUjian.setSesiLjk(x,y);
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
		//$scope.idUjian BERBENTUK OBJEK KARENA DARI NG-OPTIONS
		$http.get('http://localhost:3000/api/ujian/'+$scope.idUjian.id_ujian+'/peserta/'+$scope.idPeserta).then(function(res){
				$scope.hasilCek = res.data.data;
				if($scope.hasilCek.length <1) {
					$scope.showWarning();
				}
				else {
					$scope.setSesiUjian($scope.idUjian.id_ujian,$scope.idUjian.nm_ujian,$scope.idPeserta,$scope.idUjian.jam,$scope.idUjian.menit);
					$scope.setSesiLjk(0,'0000000');
					$location.path('/petunjuk');
				}
		}), function(res){
				$scope.showWarning();
			};
		};
	$scope.getUjian();
});
