app.controller("hasilUjian", function($scope, $http, $location, infoPesertaUjian, sesiUjian){
	$scope.hasilUjian = infoPesertaUjian.getHasilUjian();
	$scope.resetUjian = function(){
		sesiUjian.resetCookies();
		$location.path('/');
	};
});
