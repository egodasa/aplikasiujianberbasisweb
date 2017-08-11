var app = angular.module("adminAUBE", ["ngRoute","ngStorage"]);
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
    .when("/pengaturan", {
        templateUrl : "/admin/views/pengaturan.html",
        controller : "pengaturan"
    })
    .otherwise({
        redirectTo: "/"
    });
});
app.run(function($rootScope, $localStorage) {
   //$rootScope.serverBackEnd = $localStorage.serverBackEnd;
   //$rootScope.serverBackEnd = 'http://localhost:3000';
   $rootScope.serverBackEnd = 'https://ujianweb.herokuapp.com';
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
app.service('loadingScreen', 
    ['$q', '$rootScope', '$log', 
    function($q, $rootScope, $log) {
        'use strict';
 
        return {
            request: function(config) {
                $rootScope.loading = "display:block;";
                return config;
            },
            requestError: function(rejection) {
                $rootScope.loading = "display:none;";
                $log.error('Request error:', rejection);
                return $q.reject(rejection);
            },
            response: function(response) {
                $rootScope.loading = "display:none;";
                return response;
            },
            responseError: function(rejection) {
                $rootScope.loading = "display:none;";
                $log.error('Response error:', rejection);
                return $q.reject(rejection);
            }
        };
    }]);
app.config(['$httpProvider', function($httpProvider) {
    $httpProvider.interceptors.push('loadingScreen');
}]);
