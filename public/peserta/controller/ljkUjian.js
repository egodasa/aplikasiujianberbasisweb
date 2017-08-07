app.controller("ljkUjian", function($scope, $http, $location, infoPesertaUjian){
	$scope.listIdUjian = [];
	$scope.listJawaban = [];
	$scope.hasilUjian = {};
	$scope.infoPesertaUjian = infoPesertaUjian.getPesertaUjian();
	$scope.showSoalUjian = function(no_soal,id_soal){
		$http.get('http://localhost:3000/api/soal/'+id_soal).then(function(res){
			$scope.isiSoal = res.data.data[0];
			$scope.jawaban = $scope.listJawaban[no_soal].jawaban;
			infoPesertaUjian.setPosisiSoal(no_soal,id_soal);
			$scope.posisiSoal = infoPesertaUjian.getPosisiSoal();
		}), function(res){
			$scope.isiSoal =[];
			};
	};
	$scope.getSoalUjian = function(id){
		$http.get('http://localhost:3000/api/ujian/'+id+'/soal').then(function(res){
			$scope.idSoalUjian = res.data.data;
			for(var x=0;x< res.data.data.length;x++){
				$scope.listJawaban.push({no_soal : x,id_soal : res.data.data[x].id_soal,jawaban : null});
			}
		}), function(res){
			$scope.isiSoal =[];
			};
	};
	$scope.simpanJawaban = function(no_soal,id_soal,jawaban){
		if(no_soal == $scope.listJawaban[no_soal].no_soal){
			$scope.listJawaban[no_soal].id_soal = id_soal;
			$scope.listJawaban[no_soal].jawaban = jawaban;
		}
		else console.log("tidak dapat menyimpan jawaban");
	};
	$scope.kumpulkanUjian = function(){
		$scope.hasilUjian.id_peserta = $scope.infoPesertaUjian.id_peserta;
		$scope.hasilUjian.id_ujian = $scope.infoPesertaUjian.ujian.id_ujian;
		$scope.hasilUjian.hasil_ujian = [];
		for(var x=0;x<$scope.idSoalUjian.length;x++){
			if($scope.idSoalUjian[x].jawaban == $scope.listJawaban[x].jawaban) $scope.ket_jawaban = true;
			else $scope.ket_jawaban = false;
			$scope.hasilUjian.hasil_ujian.push({
				id_soal : $scope.idSoalUjian[x].id_soal,
				jawaban_soal : $scope.idSoalUjian[x].jawaban,
				jawaban_peserta : $scope.listJawaban[x].jawaban,
				keterangan : $scope.ket_jawaban
			});
		}
		infoPesertaUjian.setHasilUjian($scope.hasilUjian);
		$location.path('/ljk/hasil');
	};
	$scope.getSoalUjian($scope.infoPesertaUjian.ujian.id_ujian);
});
