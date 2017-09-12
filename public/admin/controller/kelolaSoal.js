app.controller("kelolaSoal", function($rootScope, $scope, $http, $location, $timeout) {
    $scope.pilihanGandaDefault = [{
            huruf: 'A',
            isi_pilihan: ''
        },
        {
            huruf: 'B',
            isi_pilihan: ''
        },
        {
            huruf: 'C',
            isi_pilihan: ''
        },
        {
            huruf: 'D',
            isi_pilihan: ''
        },
        {
            huruf: 'E',
            isi_pilihan: ''
        }
    ];
    $scope.pilihanGanda = [{
            huruf: 'A',
            isi_pilihan: ''
        },
        {
            huruf: 'B',
            isi_pilihan: ''
        },
        {
            huruf: 'C',
            isi_pilihan: ''
        },
        {
            huruf: 'D',
            isi_pilihan: ''
        },
        {
            huruf: 'E',
            isi_pilihan: ''
        }
    ];

    $scope.addPG = function(x) {
        if (x == 0) {
            $scope.pilihanGanda.push({
                huruf: $scope.pilihanGandaDefault[$scope.pilihanGanda.length].huruf,
                isi_pilihan: $scope.pilihanGandaDefault[$scope.pilihanGanda.length].isi_pilihan
            });
        } else if (x == 1) {
            $scope.pilihanGandaUpdate.push({
                huruf: $scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length].huruf,
                isi_pilihan: $scope.pilihanGandaDefault[$scope.pilihanGandaUpdate.length].isi_pilihan
            });
        }
    }
    $scope.deletePG = function(x) {
        if (x == 0) {
            $scope.pilihanGanda.pop();
        } else if (x == 1) {
            $scope.pilihanGandaUpdate.pop();
        }
    }
    $scope.resetForm = function(x) {
        if (x == 0) {
            $scope.Tsoal = '';
            $scope.pilihanGanda = [{
                    huruf: 'A',
                    isi_pilihan: ''
                },
                {
                    huruf: 'B',
                    isi_pilihan: ''
                },
                {
                    huruf: 'C',
                    isi_pilihan: ''
                },
                {
                    huruf: 'D',
                    isi_pilihan: ''
                },
                {
                    huruf: 'E',
                    isi_pilihan: ''
                }
            ];
            $scope.Rjawaban = '';
            $scope.ETsoal = '';
            $scope.ERjawaban = '';
        } else {
            $scope.UTsoal = '';
            $scope.pilihanGandaUpdate = [{
                    huruf: 'A',
                    isi_pilihan: ''
                },
                {
                    huruf: 'B',
                    isi_pilihan: ''
                },
                {
                    huruf: 'C',
                    isi_pilihan: ''
                },
                {
                    huruf: 'D',
                    isi_pilihan: ''
                },
                {
                    huruf: 'E',
                    isi_pilihan: ''
                }
            ];
            $scope.URjawaban = '';
            $scope.EUTsoal = '';
            $scope.EURjawaban = '';
        }
    };
    $scope.readData = function(x, y) {
        var url;
        if (x == 0 && y == 0) url = $rootScope.serverBackEnd + '/api/soal';
        else url = $rootScope.serverBackEnd + '/api/soal?limit=' + x + '&offset=' + y;
        $rootScope.showLoading(true);
        $rootScope.pagination.limit = x;
        $rootScope.pagination.offset = y;
        $http.get(url)
            .then(function(res) {
                $scope.laporanSoal = res.data.data;
                $rootScope.pagNum(res.data.row, $rootScope.pagination.limit);
            })
            .catch(function(e) {
                $rootScope.showPesan('Warning', e);
            })
            .finally(function() {
                $rootScope.showLoading(false);
            })
    };
    $scope.deleteData = function(id) {
        $rootScope.showLoading(true);
        $http.delete($rootScope.serverBackEnd + '/api/soal/' + id)
            .then(function(res) {
                var result = res.data.status;
                if (result == true) {
                    $scope.readData($rootScope.pagination.limit, $rootScope.pagination.offset);
                    $rootScope.showPesan('Success', 'Data berhasil dihapus ...');
                } else {
                    $rootScope.showPesan('Warning', 'Data gagal dihapus ...');
                    $scope.readData($rootScope.pagination.limit, $rootScope.pagination.offset);
                }
            })
            .catch(function(e) {
                $rootScope.showPesan('Warning', e);
            })
            .finally(function() {
				$rootScope.bulkDelete = [];
                $rootScope.showLoading(false);
            })
    };
    $scope.createData = function() {
        var data = {
            isi_soal: $scope.Tsoal,
            pilihanGanda: $scope.pilihanGanda,
            jawaban: $scope.Rjawaban
        };
        data = JSON.stringify(data);
        $rootScope.tombolSimpan(1);
        $http({
                method: 'POST',
                url: $rootScope.serverBackEnd + '/api/soal',
                data: data,
                contentType: 'application/json; charset=utf-8'
            }).then(function(res) {
                var hasil = res.data;
                if (hasil.status == true) {
                    $scope.resetForm(0);
                    $rootScope.showForm(0, 0);
                    $scope.readData($rootScope.pagination.limit, $rootScope.pagination.offset);
                    $rootScope.showPesan('Success', 'Data berhasil ditambahkan ...');
                } else {
                    $scope.ETsoal = hasil.error.isi_soal.msg;
                    $scope.ERjawaban = hasil.error.jawaban.msg;
                }
            })
            .catch(function(e) {
                $rootScope.showPesan('Warning', e);
            })
            .finally(function() {
				$rootScope.tombolSimpan(0);
            })
    };
    $scope.detailData = function(id) {
        $scope.idSoal = id;
        $http.get($rootScope.serverBackEnd + '/api/soal/' + id)
            .then(function(res) {
                var hasil = res.data.data[0];
                $scope.UThuruf = [];
                $scope.UTisi_pilihan = [];
                $scope.pilihanGandaUpdate = hasil.pilihanGanda;
                $scope.UTsoal = hasil.isi_soal;
                $scope.URjawaban = hasil.jawaban;
                $rootScope.showForm(1, 1);
            })
            .catch(function(e) {
                $rootScope.showPesan('Warning', e);
            })
            .finally(function() {});
    }
    $scope.updateData = function(id) {
        var data = {
            isi_soal: $scope.UTsoal,
            pilihanGanda: $scope.pilihanGandaUpdate,
            jawaban: $scope.URjawaban
        };
        data = JSON.stringify(data);
        $http({
                method: 'PUT',
                url: $rootScope.serverBackEnd + '/api/soal/' + id,
                data: data,
                contentType: 'application/json; charset=utf-8'
            }).then(function(res) {
                var hasil = res.data;
                if (hasil.status == true) {
                    $scope.resetForm(1);
                    $scope.readData($rootScope.pagination.limit, $rootScope.pagination.offset);
                    $rootScope.showForm(0, 1);
                    $rootScope.showPesan('Success', 'Perubahan disimpan...');
                } else {
                    $scope.EUTsoal = hasil.error.isi_soal.msg;
                    $scope.EURjawaban = hasil.error.jawaban.msg;
                }
            })
            .catch(function(e) {
                $rootScope.showPesan('Warning', e);
            })
            .finally(function() {})
    }
    $scope.readData($rootScope.pagination.limit, $rootScope.pagination.offset);
    $scope.$watch('form', function(newValue, oldValue, scope) {
        if (newValue == 'display:none;') scope.resetForm();
    });
});
