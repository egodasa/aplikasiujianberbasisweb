app.controller("ljkUjian", function($scope, $http, $location, sesiUjian){
	$scope.sesiUjian = sesiUjian;
	$scope.sesiUjian.cekLogin();
});
