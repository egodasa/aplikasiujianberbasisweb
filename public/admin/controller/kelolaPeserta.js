app.controller("kelolaPeserta", function($scope, $http, $location){
	$scope.resetForm = function(){
		$scope.Tnm_peserta ='';
		$scope.ETnm_peserta ='';
		$scope.UTnm_peserta ='';
		$scope.EUTnm_peserta ='';
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
		$http.get('http://localhost:3000/api/peserta').then(function(res){
			$scope.data = res.data.data;
		}), function(res){
			$scope.data_tabel ="error";
			};
		};
	$scope.deleteData = function(id){
		$http.delete('http://localhost:3000/api/peserta/delete/'+id).then(function(res){
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
			nm_peserta : $scope.Tnm_peserta
		};
		data = JSON.stringify(data);
		$http({
			method : 'POST',
			url : 'http://localhost:3000/api/peserta/create',
			data : data,
			contentType : 'application/json; charset=utf-8'
			}).then(function(res){
			var hasil = res.data;
			if(hasil.status == true){
				$scope.resetForm();
				$scope.showForm(0,0);
				$scope.readData();
			}
			else {
				$scope.ETnm_peserta = hasil.error.nm_peserta.msg;
			}
		}), function(res){
			console.log(res.data.status);
			};
		};
		$scope.detailData = function(id){
		$http.get('http://localhost:3000/api/peserta/'+id)
			.then(function(res){
				var hasil = res.data.data[0];
				$scope.id = hasil.id_peserta;
				$scope.UTnm_peserta = hasil.nm_peserta;
				$scope.showForm(1,1);
			}), function(res){
				console.log('error fetch data details');
			};
		}
		$scope.updateData = function(id){
			var data = {
				nm_peserta : $scope.UTnm_peserta
			};
			data = JSON.stringify(data);
			$http({
				method : 'PUT',
				url : 'http://localhost:3000/api/peserta/update/'+id,
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
						$scope.EUTnm_peserta = hasil.error.nm_peserta.msg;
						}
				}), function(){
					};
		}
$scope.readData();
});
