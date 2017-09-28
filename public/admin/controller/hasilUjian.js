app.controller("hasilUjian", function($rootScope, $scope, $http, $routeParams){
	$scope.id = $routeParams.idUjian;
	$scope.readData = function(id){
		$http({
			method : 'GET',
			url : $rootScope.serverBackEnd+'/api/ujian/'+id+'/hasil',
		}).then(function(res){
			$scope.hasil = res.data.data;
			console.log($scope.hasil);
			}), function(){
				$scope.hasil = [];
				};
	};
$scope.readData($scope.id);
});
