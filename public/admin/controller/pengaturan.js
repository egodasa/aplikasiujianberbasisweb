app.controller("pengaturan", function($scope, $rootScope, $http, $localStorage, $location, loadingScreen){
	$scope.simpanPengaturan = function(x){
		$localStorage.serverBackEnd = x;
		if($localStorage.serverBackEnd  == $scope.alamatServer) $location.path('/admin');
		else console.log('perubahan gagal');
	};
});
