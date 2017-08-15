app.controller("hasilUjian", function($scope, $http, $location, infoPesertaUjian, sesiUjian){
	$scope.sesiUjian = sesiUjian;
	$scope.sesiUjian.cekLogin();
	$scope.hasilUjian = infoPesertaUjian.getHasilUjian();
	$scope.resetUjian = function(){
		sesiUjian.resetCookies();
		$location.path('/');
	};
});
