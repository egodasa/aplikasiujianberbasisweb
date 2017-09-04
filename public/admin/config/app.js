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
    .when("/ujian/:idUjian/peserta", {
        templateUrl : "/admin/views/kelolaPesertaUjian.html",
        controller : "kelolaPesertaUjian"
    })
    .when("/ujian/:idUjian/soal", {
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
    .when("/ujian/:idUjian/laporan", {
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
app.run(function($rootScope, $timeout) {
   $rootScope.serverBackEnd = '';
   $rootScope.pencarian = function(x){
		$rootScope.kataKunci = x;
	};
	$rootScope.showLoading = function(x){
		if(x == true) $rootScope.loading = 'display:block;';
		else $rootScope.loading = 'display:none;';
	};
	$rootScope.showLoading(false);
	$rootScope.pesan = false;
	$rootScope.showPesan= function(tipe,isi){
		if(tipe == 'Warning') $rootScope.tipePesan = 'w3-panel w3-pink';
		else $rootScope.tipePesan = 'w3-panel w3-light-green w3-text-white';
		$rootScope.isiPesan = isi;
		$rootScope.pesan = true;
		var pesanTimer = $timeout(function () {
	        $rootScope.closePesan();
	        $timeout.cancel(pesanTimer);
	    }, 5000);
	};
	$rootScope.closePesan = function(){
		$rootScope.pesan = false;
		$rootScope.isiPesan = '';
	};
	$rootScope.createForm = false;
	$rootScope.updateForm = false;
	$rootScope.showForm = function(x,y){
		if(x == 0) {
			$rootScope.form = "display:none;";
			}
		else $rootScope.form = "display:block;";
		
		if(y == 0){
			$rootScope.createForm = true;
			$rootScope.updateForm = !$rootScope.createForm;
		}
		else{
			$rootScope.updateForm = true;
			$rootScope.createForm = !$rootScope.updateForm;
		}
	}
	//PAGINASI
	$rootScope.pagination = {
		limit : 10,
		offset : 0
	};
	$rootScope.pagNum = function(length,limit){
		var hasil = Math.ceil(length/limit);
		$rootScope.pagCount=[];
		for(x = 0;x < hasil;x++){
			$rootScope.pagCount.push(x);
		}
	};
	//bulk delete data
	$rootScope.bulkDelete = [];
	$rootScope.addBulkDelete = function(status,id){
		if(status == true) $rootScope.bulkDelete.push(id);
		else {
			var l = $rootScope.bulkDelete.length;
			for(var x=0;x < l;x++){
				if($rootScope.bulkDelete[x] == id){
					$rootScope.bulkDelete.splice(x,1);
				}
			}
		}
		console.log($rootScope.bulkDelete);		
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
