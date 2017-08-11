app.controller("hasilUjian", function($rootScope, $scope, $http, ujian){
	$scope.id_ujian = ujian.getIdUjian();
	$scope.readData = function(id){
		$http({
			method : 'GET',
			url : $rootScope.serverBackEnd+'/api/ujian/'+id+'/hasil',
		}).then(function(res){
			$scope.hasil = res.data.data;
			}), function(){
				$scope.hasil = [];
				};
	};
$scope.readData($scope.id_ujian);
});
