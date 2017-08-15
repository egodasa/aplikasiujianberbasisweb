var app = angular.module("pesertaAUBE", ["ngRoute","ngCookies","ngStorage"]);
app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/peserta/views/cekPesertaUjian.html",
        controller : "cekPesertaUjian"
    })
    .when("/petunjuk", {
        templateUrl : "/peserta/views/petunjukUjian.html"
    })
    .when("/ljk", {
        templateUrl : "/peserta/views/ljkUjian.html",
        controller : "ljkUjian"
    })
    .when("/ljk/hasil", {
        templateUrl : "/peserta/views/hasilUjian.html",
        controller : "hasilUjian"
    })
    .otherwise({
        redirectTo: "/"
    });
});
app.run(function($rootScope) {
    $rootScope.serverBackEnd = '';
});
app.service('infoPesertaUjian', function($location, $http, $rootScope){
		this.ujian;
		this.id_peserta;
		this.soalUjian;
		this.id_soal;
		this.no_soal;
		this.posisiSoal;
		this.hasilUjian;
		this.setSoalUjian = function(x){
			$http.get($rootScope.serverBackEnd+'/api/ujian/'+x+'/soal').then(function(res){
				this.soalUjian = res.data.data;
				}), function(res){
					this.soalUjian =[];
					};
		};
		this.getSoalUjian = function(){
			return this.soalUjian;
		};
		this.setPosisiSoal = function(x,y){
			this.posisiSoal = {
				no_soal : x,
				id_soal : y
				};
		};
		this.getPosisiSoal = function(){
			return this.posisiSoal;
		};
		this.setHasilUjian = function(data){
			this.hasilUjian = data;
		};
		this.getHasilUjian = function(){
			return this.hasilUjian;
		};
});

app.service('sesiUjian', function($localStorage, $location){
	this.sesi = $localStorage;
	this.getSesiUjian = function(){
		return {
			id_ujian : this.sesi.id_ujian,
			nm_ujian : this.sesi.nm_ujian,
			waktu : this.sesi.waktu,
			id_peserta : this.sesi.id_peserta
		};
	};
	this.setSesiUjian = function(x,x1,y,y1,y2){
		this.mili = y1*3600000+y2*60000;
		this.sesi.id_ujian = x;
		this.sesi.nm_ujian = x1;
		this.sesi.id_peserta = y;
		this.sesi.waktu = this.mili;
	};
	this.getSesiLjk = function(){
		return {
			no_soal : this.sesi.no_soal,
			id_soal : this.sesi.id_soal
		};
	};
	this.setSesiLjk = function(x,y){
		this.sesi.no_soal = x;
		this.sesi.id_soal = y;
	};
	this.setJawabanLjk = function(x){
		this.sesi.jawaban = x;
	};
	this.getJawabanLjk = function(){
		return this.sesi.jawaban;
	};
	this.resetCookies = function(){
		$localStorage.$reset();
	};
	this.cekLogin = function(){
		if($localStorage.id_ujian == undefined) $location.path('/peserta');
	};
});
