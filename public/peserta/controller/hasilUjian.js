app.controller("hasilUjian", function($scope, $http, $location, infoPesertaUjian){
	$scope.hasilUjian = infoPesertaUjian.getHasilUjian();
	$scope.resetUjian = function(){
		infoPesertaUjian.setPesertaUjian(null,null);
		infoPesertaUjian.setSoalUjian(null);
		infoPesertaUjian.setPosisiSoal(null);
		$location.path('/');
	};
});
