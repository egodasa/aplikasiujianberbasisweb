app.controller("kelolaSoal", function($scope, $http, $location){
	$scope.alfabet = ["A","B","C","D","E","F","G","H","I"];
	$scope.addPG = function(x){
		if(x == 0){
			$scope.Thuruf.push($scope.alfabet[$scope.Thuruf.length]);
			$scope.Tisi_pilihan.push("");
		}else {
			$scope.UThuruf.push($scope.alfabet[$scope.UThuruf.length]);
			$scope.UTisi_pilihan.push("");
		}
	}
	$scope.deletePG = function(x){
		if(x == 0){
			$scope.Thuruf.pop();
			$scope.Tisi_pilihan.pop();
		}else {
			$scope.UThuruf.pop();
			$scope.UTisi_pilihan.pop();
		}
	}
	$scope.resetForm = function(){
		$scope.Tsoal ='';
		$scope.ETsoal ='';
		$scope.UTsoal ='';
		$scope.EUTsoal ='';
		$scope.Rjawaban = '';
		$scope.Thuruf=["A","B","C"];
		$scope.Tisi_pilihan=["","",""];
	};
	$scope.createForm = false;
	$scope.updateForm = false;
	$scope.showForm = function(x,y){
		if(x == 0) {
			$scope.form = "display:none;";
			$scope.resetForm();
			}
		else $scope.form = "display:block;";
		
		if(y == 0){
			$scope.createForm = true;
			$scope.updateForm = !$scope.createForm;
		}
		else{
			$scope.updateForm = true;
			$scope.createForm = !$scope.updateForm;
		}
	}
	$scope.readData = function(){
		$http.get('http://localhost:3000/api/soal').then(function(res){
			$scope.data = res.data.data;
		}), function(res){
			$scope.data_tabel ="error";
			};
		};
	$scope.deleteData = function(id){
		$http.delete('http://localhost:3000/api/soal/delete/'+id).then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
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
			url : 'http://localhost:3000/api/soal/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			}).then(function(res){
			var hasil = res.data;
			console.log(hasil);
			if(hasil.status == true){
				$scope.resetForm();
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
		$http.get('http://localhost:3000/api/soal/'+id)
			.then(function(res){
				$scope.UThuruf = [];
				$scope.UTisi_pilihan = [];
				hasil = res.data.data[0];
				console.log(hasil);
				for(var x=0;x<hasil.pilihan_ganda.length;x++){
					$scope.UThuruf[x] = hasil.pilihan_ganda[x].huruf;
					$scope.UTisi_pilihan[x] = hasil.pilihan_ganda[x].isi_pilihan;
				}
				console.log($scope.UThuruf);
				$scope.UTsoal = hasil.isi_soal;
				$scope.URjawaban = hasil.jawaban;
				$scope.showForm(1,1);
			}), function(res){
				console.log('error fetch data details');
			};
		}
		$scope.updateData = function(id){
			for(x=0;x<$scope.Thuruf.length;x++){
			$scope.pilihan.push({huruf : $scope.Thuruf[x], isi_pilihan : $scope.Tisi_pilihan[x]});
			}
			var data = {
				isi_soal : $scope.UTsoal,
				pilihan_ganda : $scope.pilihan,
				jawaban : $scope.URjawaban
				};
			data = JSON.stringify(data);
			$http({
				method : 'PUT',
				url : 'http://localhost:3000/api/soal/update/'+id,
				data : data,
				contentType : 'application/json; charset=utf-8'
			}).then(function(res){
				var hasil = res.data;
					if(hasil.status == true){
						$scope.resetForm();
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
$scope.resetForm();
$scope.readData();
});
