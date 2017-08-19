app.controller("ljkUjian", function($scope, $rootScope, $http, $location, $interval, $cookies, $localStorage, infoPesertaUjian, sesiUjian){;
	sesiUjian.cekLogin();
	$scope.simpanWaktu = function(x){
		var menit,jam;
	};
	$interval(function(){
		$scope.tgl = new Date();
		}, 1000);
	$scope.durasiUjian = function(mili){
		var waktu = new Date();
		var finishtmp;
		waktu.setHours(0);
		waktu.setMinutes(0);
		waktu.setSeconds(0);
		waktu.setMilliseconds(0);
		$scope.startUjian = waktu.getTime();
		$scope.finishUjian = 1*$scope.startUjian + 1*mili; //SET WAKTU FINISH
		$scope.runWaktu = $interval(function(){
			$scope.finishUjian = $scope.finishUjian - 1000; //WAKTU FINISH DIPROSES HINGGA SAMA DENGAN WAKTU START
			$localStorage.waktu = $scope.finishUjian - $scope.startUjian; //SIMPAN SISA WAKTU KE COOKIES
			if($scope.finishUjian == $scope.startUjian) { //CEK WAKTU
				$interval.cancel($scope.runWaktu); //WAKTU DISTOP JIKA WAKTU SUDAH HABIS
				$scope.runWaktu = undefined;
				$scope.kumpulkanUjian(); 
			}
			}, 1000);
	};
	$scope.setJawabanLjk = function(x){
		sesiUjian.setJawabanLjk(x);
	};
	$scope.sesiUjian = sesiUjian.getSesiUjian();
	$scope.setSesiLjk = function(x,y){
		sesiUjian.setSesiLjk(x,y);
	};
	$scope.sesiLjk = sesiUjian.getSesiLjk();
	$scope.listIdUjian = [];
	$scope.listJawaban = [];
	$scope.hasilUjian = {};
	$scope.showSoalUjian = function(no_soal){
		var id_soal = $scope.idSoalUjian[no_soal].id_soal;
		$http.get($rootScope.serverBackEnd+'/api/soal/'+id_soal).then(function(res){
			//SET POSISI SOAL SEDANG DIsoalKAN KE COOKIES
			$scope.setSesiLjk(no_soal,id_soal);
			$scope.sesiLjk = sesiUjian.getSesiLjk();
			$scope.isiSoal = res.data.data[0];
			$scope.jawaban = $scope.listJawaban[no_soal].jawaban;
			//SET NOMOR SOAL UNTUK DITAMPILKAN
			$scope.noSoal = 1*no_soal+1;
		}), function(res){
			$scope.isiSoal =[];
			};
	};
	$scope.getSoalUjian = function(id){
		$http.get($rootScope.serverBackEnd+'/api/ujian/'+id+'/soal').then(function(res){
			$scope.idSoalUjian = res.data.data;
			for(var x=0;x< res.data.data.length;x++){
				$scope.listJawaban.push({no_soal : x,id_soal : res.data.data[x].id_soal,jawaban : null});
			}
			//tampilkan ujian setelah daftar id_ujian diambil
			$scope.showSoalUjian($scope.sesiLjk.no_soal);
			$scope.setJawabanLjk($scope.listJawaban);
		}), function(res){
			$scope.isiSoal =[];
			};
	};
	$scope.simpanJawaban = function(no_soal,id_soal,jawaban){
		console.log(no_soal+' '+id_soal+' '+jawaban);
		if(no_soal == $scope.listJawaban[no_soal].no_soal){
			$scope.listJawaban[no_soal].id_soal = id_soal;
			$scope.listJawaban[no_soal].jawaban = jawaban;
		$scope.setJawabanLjk($scope.listJawaban);
		console.log(sesiUjian.getJawabanLjk());
		}
		else console.log("tidak dapat menyimpan jawaban");
	};
	$scope.kumpulkanUjian = function(){
		$scope.hasilUjian.id_peserta = $scope.sesiUjian.id_peserta;
		$scope.hasilUjian.id_ujian = $scope.sesiUjian.id_ujian;
		$scope.hasilUjian.hasil_ujian = [];
		var jawabanBenar=0;
		var jawabanSalah=0;
		for(var x=0;x<$scope.idSoalUjian.length;x++){ //MEMBANDINGKAN JAWABAN DAN MENGETAHUI BENAR SALAH SOAL
			if($scope.idSoalUjian[x].jawaban == $scope.listJawaban[x].jawaban) {
				$scope.ket_jawaban = true;
				jawabanBenar++;
			}
			else {
				$scope.ket_jawaban = false;
				jawabanSalah++;
			}
			$scope.hasilUjian.hasil_ujian.push({
				id_soal : $scope.idSoalUjian[x].id_soal,
				jawaban_soal : $scope.idSoalUjian[x].jawaban,
				jawaban_peserta : $scope.listJawaban[x].jawaban,
				keterangan : $scope.ket_jawaban
			});
		}
		var data = {
				id_ujian : $scope.sesiUjian.id_ujian,
				id_peserta : $scope.sesiUjian.id_peserta,
				benar : jawabanBenar,
				salah : jawabanSalah
			};
		data = JSON.stringify(data);
		console.log(data);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/ujian/'+$scope.sesiUjian.id_ujian+'/hasil',
			contentType : 'application/json; charset=utf-8',
			data : data
			}).then(function(){
				if($scope.runWaktu != undefined) $interval.cancel($scope.runWaktu); //MENGHENTIKAN TIMER JIKA TOMBOL KUMPULKAN UJIAN DITEKAN
				infoPesertaUjian.setHasilUjian($scope.hasilUjian);
				sesiUjian.resetCookies();
				$location.path('/ljk/hasil');
			}), function(){
				console.log('tidak dapat menyimpan jawaban');
		};
	};
	$scope.simpanHasilUjian = function(){
		$scope.listJawaban
	};
	if(sesiUjian.getJawabanLjk()) $scope.listJawaban = sesiUjian.getJawabanLjk(); //JAWABAN DISIMPAN KE COOKIES AGAR PERSISTENT
	$scope.getSoalUjian($scope.sesiUjian.id_ujian);
	$scope.durasiUjian($scope.sesiUjian.waktu);
});
