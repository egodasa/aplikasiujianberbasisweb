app.controller("kelolaSoal", function($rootScope, $scope, $http, $location, $timeout){
	$scope.showLoading = function(x){
		if(x == true) $rootScope.loading = 'display:block;';
		else $rootScope.loading = 'display:none;';
	};
	$scope.showLoading(false);
	$scope.showPesan= function(tipe,isi){
		if(tipe == 'Warning') $scope.tipePesan = 'w3-panel w3-pale-red';
		else $scope.tipePesan = 'w3-panel w3-pale-green';
		$scope.isiPesan = isi;
		$scope.pesan = true;
		var pesanTimer = $timeout(function () {
	        $scope.closePesan();
	        $timeout.cancel(pesanTimer);
	    }, 5000);
	};
	$scope.closePesan = function(){
		$scope.pesan = false;
		$scope.isiPesan = '';
	};
	$scope.pilihanGandaDefault = [
	{huruf : 'A', isi_pilihan : ''},
	{huruf : 'B', isi_pilihan : ''},
	{huruf : 'C', isi_pilihan : ''},
	{huruf : 'D', isi_pilihan : ''},
	{huruf : 'E', isi_pilihan : ''}
	];
	$scope.pilihanGanda = [
	{huruf : 'A', isi_pilihan : ''},
	{huruf : 'B', isi_pilihan : ''},
	{huruf : 'C', isi_pilihan : ''},
	{huruf : 'D', isi_pilihan : ''},
	{huruf : 'E', isi_pilihan : ''}
	];

	$scope.addPG = function(x){
		if(x == 0){
			$scope.pilihanGanda.push({huruf : $scope.pilihanGandaDefault[$scope.pilihanGanda.length].huruf,isi_pilihan :$scope.pilihanGandaDefault[$scope.pilihanGanda.length].isi_pilihan});
		}
		else if(x == 1){
			$scope.pilihanGandaUpdate.push({huruf : $scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length].huruf,isi_pilihan :$scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length].isi_pilihan});
		}
	}
	$scope.deletePG = function(x){
		if(x == 0){
			$scope.pilihanGanda.pop();
		}
		else if(x == 1){
			$scope.pilihanGandaUpdate.pop();
		}
	}
	$scope.resetForm = function(x){
		if(x == 0){
			$scope.Tsoal = '';
			$scope.pilihanGanda = $scope.pilihanGandaDefault;
			$scope.Rjawaban = '';
			$scope.ETsoal = '';
			$scope.ERjawaban = '';
		}
		else {
			$scope.UTsoal = '';
			$scope.pilihanGandaUpdate = $scope.pilihanGandaDefault;
			$scope.URjawaban = '';
			$scope.EUTsoal = '';
			$scope.EURjawaban = '';
		}
	};
	$scope.createForm = false;
	$scope.updateForm = false;
	$scope.form = "display:none;";
	$scope.showForm = function(x,y){
		if(x == 0){
			$scope.createForm = false;
			$scope.updateForm = false;
			$scope.form = "display:none;";
		}
		else {
			if(y == 0){
				$scope.createForm = !$scope.updateForm;
			}
			else $scope.updateForm = !$scope.createForm;
			$scope.form = "display:block;";
		}
	};
	$scope.readData = function(){
		$scope.showLoading(true);
		$http.get($rootScope.serverBackEnd+'/api/soal')
		.then(function(res){
			$scope.laporanSoal = res.data.data;
		})
		.catch(function(e){
			$scope.showPesan('Warning',e);
		})
		.finally(function(){
			$scope.showLoading(false);
		})
		};
	$scope.deleteData = function(id){
		$scope.showLoading(true);
		$http.delete($rootScope.serverBackEnd+'/api/soal/delete/'+id)
		.then(function(res){
			var result = res.data.status;
			if(result == true){
				$scope.readData();
				$scope.showPesan('Success','Data berhasil dihapus ...');
			}
			else {
				$scope.showPesan('Warning','Data gagal dihapus ...');
				$scope.readData();
			}
		})
		.catch(function(e){
			$scope.showPesan('Warning',e);
		})
		.finally(function(){
			$scope.showLoading(false);
		})
		};
	$scope.createData = function(){
		var data = {
			isi_soal : $scope.Tsoal,
			pilihan_ganda : $scope.pilihanGanda,
			jawaban : $scope.Rjawaban
		};
		console.log($scope.Rjawaban);
		data = JSON.stringify(data);
		console.log(data);
		$http({
			method : 'POST',
			url : $rootScope.serverBackEnd+'/api/soal/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			}).then(function(res){
			var hasil = res.data;
			console.log(hasil);
			if(hasil.status == true){
				$scope.resetForm(0);
				$scope.showForm(0,0);
				$scope.readData();
				$scope.showPesan('Success','Data berhasil ditambahkan ...');
			}
			else {
				$scope.ETsoal = hasil.error.isi_soal.msg;
				$scope.ERjawaban = hasil.error.jawaban.msg;
			}
		})
		.catch(function(e){
			$scope.showPesan('Warning',e);
		})
		.finally(function(){
			
		})
			};
		$scope.detailData = function(id){
		$scope.idSoal = id;
		$http.get($rootScope.serverBackEnd+'/api/soal/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.UThuruf = [];
				$scope.UTisi_pilihan = [];
				$scope.pilihanGandaUpdate = hasil.pilihan_ganda;
				$scope.UTsoal = hasil.isi_soal;
				$scope.URjawaban = hasil.jawaban;
				$scope.showForm(1,1);
			})
			.catch(function(e){
				$scope.showPesan('Warning',e);
			})
			.finally(function(){
			});
		}
		$scope.updateData = function(id){
			var data = {
				isi_soal : $scope.UTsoal,
				pilihan_ganda : $scope.pilihanGandaUpdate,
				jawaban : $scope.URjawaban
				};
			data = JSON.stringify(data);
			$http({
				method : 'PUT',
				url : $rootScope.serverBackEnd+'/api/soal/update/'+id,
				data : data,
				contentType : 'application/json; charset=utf-8'
			}).then(function(res){
				var hasil = res.data;
					if(hasil.status == true){
						$scope.resetForm(1);
						$scope.readData();
						$scope.showForm(0,1);
						$scope.showPesan('Success','Perubahan disimpan...');
						}
					else {
						$scope.EUTsoal = hasil.error.isi_soal.msg;
						$scope.EURjawaban = hasil.error.jawaban.msg;
					}
				})
				.catch(function(e){
					$scope.showPesan('Warning',e);
				})
				.finally(function(){
				})
		}
$scope.readData();
});
