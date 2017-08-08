app.controller("kelolaUjian", function($scope, $http, $location, ujian){
	$scope.setIdUjian = function(x,y){
		ujian.setIdUjian(x,y);
	};
	$scope.resetForm = function(){
		$scope.Tnm_ujian = '';
		$scope.ETnm_ujian = '';
		$scope.Tjam = '';
		$scope.ETjam = '';
		$scope.Tmenit = '';
		$scope.ETmenit = '';
		$scope.EUTnm_ujian = '';
		$scope.UTnm_ujian = '';
		$scope.EUTjam = '';
		$scope.UTjam = '';
		$scope.EUTmenit = '';
		$scope.UTmenit = '';
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
		$http.get('http://localhost:3000/api/ujian').then(function(res){
			$scope.data = res.data.data;
		}), function(res){
			$scope.data_tabel ="error";
			};
		};
	$scope.deleteData = function(id){
		$http({
			method : 'DELETE',
			url : 'http://localhost:3000/api/ujian/delete/'+id,
			contentType : 'application/json; charset=utf-8'
			}).then(function(res){
			$scope.result = res.data.status;
			if($scope.result == true){
				console.log("data berhasil dihapus");
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
		var data = {
			nm_ujian : $scope.Tnm_ujian,
			jam : $scope.Tjam,
			menit : $scope.Tmenit
		};
		data = JSON.stringify(data);
		$http({
			method : 'POST',
			url : 'http://localhost:3000/api/ujian/create',
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
				$scope.ETnm_ujian = hasil.error.nm_ujian.msg;
				$scope.ETjam = hasil.error.jam.msg;
				$scope.ETmenit = hasil.error.menit.msg;
			}
		}), function(res){
			console.log(res.data.status);
			};
		};
		$scope.detailData = function(id){
		$http.get('http://localhost:3000/api/ujian/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.resetForm();
				$scope.id = hasil.id_ujian;
				$scope.UTnm_ujian = hasil.nm_ujian;
				$scope.UTjam = hasil.jam;
				$scope.UTmenit = hasil.menit;
				$scope.showForm(1,1);
			}), function(res){
				console.log('error fetch data details');
			};
		}
		$scope.updateData = function(id){
			var data = {
				nm_ujian : $scope.UTnm_ujian,
				jam : $scope.UTjam,
				menit : $scope.UTmenit
			};
			data = JSON.stringify(data);
			$http({
				method : 'PUT',
				url : 'http://localhost:3000/api/ujian/update/'+id,
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
						$scope.EUTnm_ujian = hasil.error.nm_ujian.msg;
						$scope.EUTjam = hasil.error.jam.msg;
						$scope.EUTmenit = hasil.error.menit.msg;
						}
				}), function(){
					};
		}
$scope.readData();
});
