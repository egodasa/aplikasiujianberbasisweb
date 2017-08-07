var app = angular.module("pesertaAUBE", ["ngRoute"]);
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
		this.setPesertaUjian = function(x,y){
			this.id_ujian = x;
			this.id_peserta = y;
		};
		this.getPesertaUjian = function(){
			this.detail = {
				ujian : this.id_ujian,
				id_peserta : this.id_peserta
			};
			return this.detail;
		};
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

