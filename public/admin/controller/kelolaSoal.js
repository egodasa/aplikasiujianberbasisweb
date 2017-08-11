app.controller("kelolaSoal", function($rootScope, $scope, $http, $location){
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
	$scope.Thuruf =[];
	$scope.Tisi_pilihan =[];
	for(x = 0;x<$scope.pilihanGanda.length;x++){
		$scope.Thuruf.push($scope.pilihanGanda[x].huruf);
		$scope.Tisi_pilihan.push($scope.pilihanGanda[x].isi_pilihan);
	};
	$scope.Thuruf =
	$scope.addPG = function(x){
		if(x == 0){
			$scope.pilihanGanda.push($scope.pilihanGandaDefault[$scope.pilihanGanda.length]);
			$scope.Thuruf.push($scope.pilihanGandaDefault[$scope.pilihanGanda.length]);
			$scope.Tisi_pilihan.push($scope.pilihanGandaDefault[$scope.pilihanGanda.length]);
		}
		else if(x == 1){
			$scope.pilihanGandaUpdate.push($scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length]);
			$scope.UThuruf.push($scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length]);
			$scope.UTisi_pilihan.push($scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length]);
		}
	}
	$scope.deletePG = function(x){
		if(x == 0){
			$scope.pilihanGanda.pop();
			$scope.Thuruf.pop();
			$scope.Tisi_pilihan.pop();
		}
		else if(x == 1){
			$scope.pilihanGandaUpdate.pop();
			$scope.UThuruf.pop();
			$scope.UTisi_pilihan.pop();
		}
	}
	$scope.resetForm = function(x){
		if(x == 0){
			$scope.Tsoal = '';
			$scope.pilihanGanda = $scope.pilihanGandaDefault;
			$scope.Thuruf = [];
			$scope.Tisi_pilihan = [];
			$scope.Rjawaban = '';
			$scoep.ETsoal = '';
			$scope.ERjawaban = '';
		}
		else {
			$scope.UTsoal = '';
			$scope.pilihanGandaUpdate = $scope.pilihanGandaDefault;
			$scope.UThuruf = [];
			$scope.UTisi_pilihan = [];
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
			$scope.resetForm(0);
			$scope.resetForm(1);
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
		$http.get($rootScope.serverBackEnd+'/api/soal').then(function(res){
			$scope.laporanSoal = res.data.data;
		}), function(res){
			$scope.laporanSoal = [];
			};
		};
	$scope.deleteData = function(id){
		$http.delete($rootScope.serverBackEnd+'/api/soal/delete/'+id).then(function(res){
			var result = res.data.status;
			if(result == true){
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
	$scope.createData = function(){
		$scope.pilihan = [];
		for(x=0;x<$scope.Thuruf.length;x++){
			$scope.pilihan.push({huruf : $scope.Thuruf[x], isi_pilihan : $scope.Tisi_pilihan[x]});
		}
		var data = {
			isi_soal : $scope.Tsoal,
			pilihan_ganda : $scope.pilihan,
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
			}
			else {
				$scope.ETsoal = hasil.error.isi_soal.msg;
				$scope.ERjawaban = hasil.error.jawaban.msg;
			}
		}), function(res){
			console.log(res.data.status);
			};
		};
		$scope.detailData = function(id){
		$scope.idSoal = id;
		$http.get($rootScope.serverBackEnd+'/api/soal/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.UThuruf = [];
				$scope.UTisi_pilihan = [];
				$scope.pilihanGandaUpdate = hasil.pilihan_ganda;
				for(x = 0;x<$scope.pilihanGandaUpdate.length;x++){
					$scope.UThuruf[x] = $scope.pilihanGandaUpdate[x].huruf;
					$scope.UTisi_pilihan[x] = $scope.pilihanGandaUpdate[x].isi_pilihan;
				};
				$scope.UTsoal = hasil.isi_soal;
				$scope.URjawaban = hasil.jawaban;
				$scope.showForm(1,1);
			}), function(res){
				console.log('error fetch data details');
			};
		}
		$scope.updateData = function(id){
			$scope.pilihan = [];
			for(x=0;x<$scope.UThuruf.length;x++){
			$scope.pilihan.push({huruf : $scope.UThuruf[x], isi_pilihan : $scope.UTisi_pilihan[x]});
			}
			var data = {
				isi_soal : $scope.UTsoal,
				pilihan_ganda : $scope.pilihan,
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
						}
					else {
						$scope.EUTsoal = hasil.error.isi_soal.msg;
						$scope.EURjawaban = hasil.error.jawaban.msg;
					}
				}), function(){
					};
		}
$scope.readData();
});
