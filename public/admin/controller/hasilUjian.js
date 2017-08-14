app.controller("hasilUjian", function($rootScope, $scope, $http, $routeParams){
	$scope.id_ujian = $routeParams.idUjian;
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
