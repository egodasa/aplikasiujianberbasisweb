var app = angular.module("pesertaAUBE", ["ngRoute","ngCookies"]);
app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/peserta/views/cekPesertaUjian.html",
        controller : "cekPesertaUjian"
    })
    .when("/petunjuk", {
        templateUrl : "/peserta/views/petunjukUjian.html",
        controller : "ljkUjian"
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
app.service('infoPesertaUjian', function($location, $http){
		this.ujian;
		this.id_peserta;
		this.soalUjian;
		this.id_soal;
		this.no_soal;
		this.posisiSoal;
		this.hasilUjian;
		this.setSoalUjian = function(x){
			$http.get('http://localhost:3000/api/ujian/'+x+'/soal').then(function(res){
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

app.service('sesiUjian', function($cookies){
	this.getSesiUjian = function(){
		return {
			id_ujian : $cookies.get('id_ujian'),
			nm_ujian : $cookies.get('nm_ujian'),
			id_peserta : $cookies.get('id_peserta')
		};
	};
	this.setSesiUjian = function(x,x1,y){
		$cookies.put('id_ujian',x);
		$cookies.put('nm_ujian',x1);
		$cookies.put('id_peserta',y);
	};
	this.getSesiLjk = function(){
		return {
			no_soal : $cookies.get('no_soal'),
			id_soal : $cookies.get('id_soal')
		};
	};
	this.setSesiLjk = function(x,y){
		$cookies.put('no_soal',x);
		$cookies.put('id_soal',y);
	};
});
