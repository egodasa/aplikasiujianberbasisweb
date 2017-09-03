app.controller("kelolaUjian", function($rootScope, $scope, $http, $location, ujian, $timeout) {
    $scope.showLoading = function(x) {
        if (x == true) $rootScope.loading = 'display:block;';
        else $rootScope.loading = 'display:none;';
    };
    $scope.showLoading(false);
    $scope.showPesan = function(tipe, isi) {
        if (tipe == 'Warning') $scope.tipePesan = 'w3-panel w3-red';
        else $scope.tipePesan = 'w3-panel w3-pale-green';
        $scope.isiPesan = isi;
        $scope.pesan = true;
        var pesanTimer = $timeout(function() {
            $scope.closePesan();
            $timeout.cancel(pesanTimer);
        }, 5000);
    };
    $scope.closePesan = function() {
        $scope.pesan = false;
        $scope.isiPesan = '';
    };
    $scope.createForm = false;
    $scope.updateForm = false;
    $scope.form = "display:none;";
    $scope.showForm = function(x, y) {
        if (x == 0) {
            $scope.form = "display:none;";
            $scope.resetForm(0);
            $scope.resetForm(1);
        } else {
            if (y == 0) {
                $scope.createForm = !$scope.updateForm;
            } else $scope.updateForm = !$scope.createForm;
            $scope.form = "display:block;";
        }
    }
    $scope.setIdUjian = function(x, y) {
        ujian.setIdUjian(x, y);
    };
    $scope.resetForm = function(x) {
        if (x == 0) {
            $scope.Tnm_ujian = '';
            $scope.ETnm_ujian = '';
            $scope.Tjam = '';
            $scope.ETjam = '';
            $scope.Tmenit = '';
            $scope.ETmenit = '';
        } else {
            $scope.EUTnm_ujian = '';
            $scope.UTnm_ujian = '';
            $scope.EUTjam = '';
            $scope.UTjam = '';
            $scope.EUTmenit = '';
            $scope.UTmenit = '';
        }
    };
    $scope.readData = function() {
        $scope.showLoading(true);
        $http.get($rootScope.serverBackEnd + '/api/ujian')
            .then(function(res) {
                $scope.data = res.data.data;
            }).catch(function(e) {
                $scope.showPesan('Warning', e);
            }).finally(function() {
                $scope.showLoading(false);
            });
    };
    $scope.deleteData = function(id) {
        $scope.showLoading(true);
        $http({
                method: 'DELETE',
                url: $rootScope.serverBackEnd + '/api/ujian/delete/' + id,
                contentType: 'application/json; charset=utf-8'
            })
            .then(function(res) {
                var result = res.data.status;
                if (result == true) {
                    $scope.showPesan('Success', 'Data berhasil di<b>Hapus</b> ...');
                    $scope.readData();
                } else {
                    var result = res.data;
                    $scope.showPesan('Warning', 'Telah terjadi kesalahan. <br/> Pesan error : ' + res.data.error);
                }
            })
            .catch(function(e) {
                $scope.showPesan('Warning', e);
            })
            .finally(function() {
                $scope.showLoading(false);
            });
    };
    $scope.createData = function() {
        var data = {
            nm_ujian: $scope.Tnm_ujian,
            jam: $scope.Tjam,
            menit: $scope.Tmenit
        };
        data = JSON.stringify(data);
        $http({
                method: 'POST',
                url: $rootScope.serverBackEnd + '/api/ujian/create',
                data: data,
                contentType: 'application/json; charset=utf-8'
            })
            .then(function(res) {
                var hasil = res.data;
                if (hasil.status == true) {
                    $scope.resetForm();
                    $scope.showForm(0, 0);
                    $scope.showPesan('Success', 'Data baru berhasil ditambahkan ...');
                    $scope.readData();
                } else {
                    $scope.ETnm_ujian = hasil.error.nm_ujian.msg;
                    $scope.ETjam = hasil.error.jam.msg;
                    $scope.ETmenit = hasil.error.menit.msg;
                }
            })
            .catch(function(e) {
                $scope.showPesan('Warning', e);
            })
            .finally(function() {

            });
    };
    $scope.detailData = function(id) {
        $http.get($rootScope.serverBackEnd + '/api/ujian/' + id)
            .then(function(res) {
                var hasil = res.data.data[0];
                $scope.id = hasil.id_ujian;
                $scope.UTnm_ujian = hasil.nm_ujian;
                $scope.UTjam = hasil.jam;
                $scope.UTmenit = hasil.menit;
                $scope.showForm(1, 1);
            }).catch(function(e) {
                $scope.showPesan('Warning', 'Telah terjadi kesalahan. <br/> Pesan error : ' + e);
            }).finally(function() {});
    }
    $scope.updateData = function(id) {
        var data = {
            nm_ujian: $scope.UTnm_ujian,
            jam: $scope.UTjam,
            menit: $scope.UTmenit
        };
        data = JSON.stringify(data);
        $http({
                method: 'PUT',
                url: $rootScope.serverBackEnd + '/api/ujian/update/' + id,
                data: data,
                contentType: 'application/json; charset=utf-8'
            })
            .then(function(res) {
                var hasil = res.data;
                if (hasil.status == true) {
                    $scope.resetForm();
                    $scope.readData();
                    $scope.showForm(0, 1);
                    $scope.showPesan('Success', 'Perubahan disimpan ...');
                } else {
                    $scope.EUTnm_ujian = hasil.error.nm_ujian.msg;
                    $scope.EUTjam = hasil.error.jam.msg;
                    $scope.EUTmenit = hasil.error.menit.msg;
                }
            })
            .catch(function(e) {
                $scope.showForm(0, 1);
                $scope.showPesan('Warning', e);
            })
            .finally(function() {

            })
    }
    $scope.readData();
});
