app.controller("hasilUjian", function($scope, $http, $location, infoPesertaUjian){
	$scope.hasilUjian = infoPesertaUjian.getHasilUjian();
	$scope.resetUjian = function(){
		infoPesertaUjian.setPesertaUjian(null,null);
		infoPesertaUjian.setSoalUjian(null);
		infoPesertaUjian.setPosisiSoal(null);
		$cookies.remove('id_ujian');
		$cookies.remove('id_peserta');
		$cookies.remove('no_kerja');
		$location.path('/');
	};
});
