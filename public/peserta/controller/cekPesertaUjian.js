app.controller("cekPesertaUjian", function($scope, $rootScope, $http, $location, $cookies, $localStorage, infoPesertaUjian, sesiUjian){
	$scope.sesiUjian = sesiUjian;
	$scope.setSesiUjian = function(x,y,z,a,b){
		sesiUjian.setSesiUjian(x,y,z,a,b);
	};
	$scope.setSesiLjk = function(x,y){
		sesiUjian.setSesiLjk(x,y);
	};
	$scope.pesanWarning = false;
	$scope.showWarning = function(isi){
		$scope.isiPesan = isi;
		$scope.pesanWarning = false;
		$scope.pesanWarning = !$scope.pesanWarning;
	}
	$scope.closeWarning = function(){
		$scope.pesanWarning = false;
	};
	$scope.setSoalUjian = function(x){
		infoPesertaUjian.setSoalUjian(x);
	};
	$scope.getUjian = function(){
		$http.get($rootScope.serverBackEnd+'/api/ujian').then(function(res){
			$scope.listUjian = res.data.data;
		}), function(res){
			$scope.listUjian =[];
			};
		};
	$scope.cekPeserta = function(){
		//$scope.idUjian BERBENTUK OBJEK KARENA DARI NG-OPTIONS
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+$scope.idUjian.id_ujian+'/peserta/'+$scope.idPeserta).then(function(res){
				$scope.hasilCek = res.data.data;
				console.log($scope.hasilCek);
				if($scope.hasilCek.length <1) {
					$scope.showWarning('Anda tidak terdaftar diujian ini ...');
				}
				else {
						if($scope.hasilCek[0].status == 'Sudah'){
						$scope.showWarning('Anda sudah mengikuti ujian ini ...');
					}
					else {
						if($scope.sesiUjian.getSesiUjian().id_ujian == undefined){
							sesiUjian.setSesiUjian($scope.idUjian.id_ujian,$scope.idUjian.nm_ujian,$scope.idPeserta,$scope.idUjian.jam,$scope.idUjian.menit);
							sesiUjian.setSesiLjk(0,'0000000');
							$location.path('/petunjuk');
						}
						else {
							$location.path('/ljk');
						}
					}
				}
		}), function(res){
				$scope.showWarning();
			};
		};
	$scope.getUjian();
	if(sesiUjian.getSesiUjian() == undefined) console.log('sesi kosong');
	else {
		console.log('sesi berisi');
		console.log(sesiUjian.getSesiUjian());
	}
});
