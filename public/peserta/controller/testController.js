app.controller("ljkUjian", function($scope, $http, $location, infoPesertaUjian){
	/*
	$scope.listIdUjian = [];
	$scope.noKerja = infoPesertaUjian.getNoKerja();
	$scope.infoPesertaUjian = infoPesertaUjian.getPesertaUjian();
	$scope.getIdSoal = function(){
		$http.get('http://localhost:3000/api/ujian/'+$scope.infoPesertaUjian.ujian.id_ujian+'/soal').then(function(res){
			$scope.listIdUjian = [];
			for(var x=0;x<res.data.data.length;x++){
				$scope.listIdUjian.push(res.data.data[x].id_soal);
			}
		}), function(res){
			$scope.listUjian =[];
			};
	};
	$scope.showSoalUjian = function(id_soal){
		$http.get('http://localhost:3000/api/soal/'+id_soal).then(function(res){
			$scope.isiSoal = res.data.data;
		}), function(res){
			$scope.isiSoal =[];
			};
	};
	$scope.getIdSoal();
	$scope.showSoalUjian();
	console.log($scope.isiSoal);
	console.log('No kerja '+$scope.noKerja);
	console.log('info peserta '+$scope.infoPesertaUjian);
	console.log($scope.listIdUjian);
	* */
	$scope.tampilData = function(){
		$http.get('http://localhost:3000/api/soal/0000002').then(function(res){
			$scope.isiSoal = res.data.data[0];
			}), function(res){
					$scope.daftar = [];
				};
	};
	$scope.tampilData();
});
