var app = angular.module("adminAUBE", ["ngRoute"]);
app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/admin/views/home.html"
    })
    .when("/ujian", {
        templateUrl : "/admin/views/kelolaUjian.html",
        controller : "kelolaUjian"
    })
    .when("/ujian/peserta", {
        templateUrl : "/admin/views/kelolaPesertaUjian.html",
        controller : "kelolaPesertaUjian"
    })
    .when("/ujian/soal", {
        templateUrl : "/admin/views/kelolaSoalUjian.html",
        controller : "kelolaSoalUjian"
    })
    .when("/peserta", {
        templateUrl : "/admin/views/kelolaPeserta.html",
        controller : "kelolaPeserta"
    })
    .when("/soal", {
        templateUrl : "/admin/views/kelolaSoal.html",
        controller : "kelolaSoal"
    })
    .when("/ujian/laporan", {
        templateUrl : "/admin/views/hasilUjian.html",
        controller : "hasilUjian"
    })
    .when("/test", {
        templateUrl : "/test.html"
    })
    .otherwise({
        redirectTo: "/"
    });
});
app.service('ujian', function($location){
		this.id_ujian = "";
		this.setIdUjian = function(x,y){
			this.id_ujian = x;
			if(y == 0) $location.path('/ujian/peserta');
			else if(y == 1) $location.path('/ujian/soal');
			else if(y == 2) $location.path('/ujian/laporan');
			else $location.path('/ujian/soal');
		};
		this.getIdUjian = function(){
			return this.id_ujian;
		};
		this.removeIdUjian = function(){
			id_ujian = "";
			$location.path('/');
		};
	});

