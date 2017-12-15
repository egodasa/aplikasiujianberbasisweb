let validator = {
    kelas: {
        'nm_kelas': {
            notEmpty: {
                errorMessage: 'Nama kelas harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 3,
                    max: 10
                }],
                errorMessage: 'Nama kelas maksimal 10 karakter ...'
            }
        }
    },
    dosen: {
        'nm_dosen': {
            notEmpty: {
                errorMessage: 'Nama dosen harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Nama dosen harus berisikan minimal 1 karakter dan maksimal 100 karakter ...'
            }
        },
        'nidn': {
            notEmpty: {
                errorMessage: 'NIDN harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 10,
                    max: 15
                }],
                errorMessage: 'NIDN harus berisikan 15 karakter ...'
            }
        }
    },
    kuliah: {
        'nidn': {
            notEmpty: {
                errorMessage: 'Dosen harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 10,
                    max: 11
                }],
                errorMessage: 'NIDN harus berisikan 11 karakter ...'
            }
        },
        'kd_matkul': {
            notEmpty: {
                errorMessage: 'Matkul harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 15
                }],
                errorMessage: 'Kode matkul maksimal 100 karakter ...'
            }
        },
        'tahun_akademik': {
            notEmpty: {
                errorMessage: 'Tahun akademik harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 4,
                    max: 5
                }],
                errorMessage: 'Tahun akademik maksimal 5 karakter ...'
            }
        },
        'kelas': {
            notEmpty: {
                errorMessage: 'Kelas harus diisi ...'
            }
        }
    },
    matkul: {
        'kd_matkul': {
            notEmpty: {
                errorMessage: 'Kode matkul harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 14,
                    max: 15
                }],
                errorMessage: 'Kode matkul tidak benar ...'
            }
        },
        'nm_matkul': {
            notEmpty: {
                errorMessage: 'Nama matkul harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 2,
                    max: 100
                }],
                errorMessage: 'Nama matkul maksimal 100 karakter ...'
            }
        },
        'sks': {
            notEmpty: {
                errorMessage: 'SKS harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 10
                }],
                errorMessage: 'SKS tidak benar ...'
            }
        },
        'smt': {
            notEmpty: {
                errorMessage: 'Semester harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 20
                }],
                errorMessage: 'Semester tidak benar ...'
            }
        }
    },
    mahasiswa: {
        'nm_mahasiswa': {
            notEmpty: {
                errorMessage: 'Nama mahasiswa harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Nama mahasiswa maksimal 100 karakter ...'
            }
        },
        'nobp': {
            notEmpty: {
                errorMessage: 'NOBP harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 14,
                    max: 15
                }],
                errorMessage: 'NOBP tidak benar ...'
            }
        }
    },
    peserta_kuliah: {
        'nobp': {
            notEmpty: {
                errorMessage: 'NOBP harus diisi ...'
            }
        },
        'id_kelas': {
            notEmpty: {
                errorMessage: 'Kelas tidak boleh kosong ...'
            }
        }
    },
    jenis_soal: {
        'nm_jsoal': {
            notEmpty: {
                errorMessage: 'Nama jenis Soal harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 20
                }],
                errorMessage: 'Nama jenis soal maksimal 20 karakter ...'
            }
        }
    },
    jenis_ujian: {
        'nm_jujian': {
            notEmpty: {
                errorMessage: 'Nama jenis Soal harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 10
                }],
                errorMessage: 'Nama jenis Soal maksimal 10 karakter ...'
            }
        }
    },
    ujian: {
        'deskripsi': {
            notEmpty: {
                errorMessage: 'Deskripsi ujian harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Deskripsi ujian maksimal 100 karakter ...'
            }
        },
        'mulai': {
            notEmpty: {
                errorMessage: 'Jam mulai harus diisi ...'
            }
        },
        'selesai': {
            notEmpty: {
                errorMessage: 'Jam selesai harus diisi ...'
            }
        },
        'hari': {
            notEmpty: {
                errorMessage: 'Hari ujian harus diisi ...'
            }
        },
        'id_jujian': {
            notEmpty: {
                errorMessage: 'Jenis ujian harus diisi ...'
            },
            isInt: {
                errorMessage: "Id ujian tidak valid ..."
            }
        },
        'id_jsoal': {
            notEmpty: {
                errorMessage: 'Jenis soal harus diisi ...'
            },
            isInt: {
                errorMessage: "Id ujian tidak valid ..."
            }
        },
        'id_kuliah': {
            notEmpty: {
                errorMessage: 'Kuliah harus diisi ...'
            },
            isLength: {
                options: {
                    min: 1,
                    max: 40
                },
                errorMessage: "Id kuliah tidak valid"
            }
        }
    },
    soal: {
        'isi_soal': {
            notEmpty: {
                errorMessage: 'Soal harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 3,
                    max: 3000
                }],
                errorMessage: 'Isi soal maksimal 3000 karakter ...'
            }
        },
        'jawaban': {
            notEmpty: {
                errorMessage: 'Jawaban harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 3,
                    max: 3000
                }],
                errorMessage: 'Jawaban maksimal 3000 karakter ...'
            }
        },
        'bobot': {
            notEmpty: {
                errorMessage: 'Bobot nilai harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Bobot nilai maksimal 100 ...'
            }
        },
        'id_jsoal': {
            notEmpty: {
                errorMessage: 'Jenis soal harus diisi ...'
            }
        },
        'pilihanGanda': {
            notEmpty: {
                errorMessage: 'Pilihan Ganda harus diisi ...'
            }
        }
    },
    soal_ujian: {
        'id_ujian': {
            notEmpty: {
                errorMessage: 'Id ujian diisi ...'
            },
            isLength: {
                options: [{
                    min: 3,
                    max: 60
                }],
                errorMessage: 'Id ujian maksimal 60 karakter ...'
            }
        },
        'isi_soal': {
            notEmpty: {
                errorMessage: 'Soal harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 3,
                    max: 3000
                }],
                errorMessage: 'Isi soal maksimal 3000 karakter ...'
            }
        },
        'jawaban': {
            notEmpty: {
                errorMessage: 'Jawaban harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 3,
                    max: 3000
                }],
                errorMessage: 'Jawaban maksimal 3000 karakter ...'
            }
        },
        'bobot': {
            notEmpty: {
                errorMessage: 'Bobot nilai harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Bobot nilai maksimal 100 ...'
            }
        },
        'id_jsoal': {
            notEmpty: {
                errorMessage: 'Jenis soal harus diisi ...'
            }
        },
        'pilihanGanda': {
            notEmpty: {
                errorMessage: 'Pilihan Ganda harus diisi ...'
            }
        }
    },
    user: {
        'username': {
            notEmpty: {
                errorMessage: 'Username harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 6,
                    max: 30
                }],
                errorMessage: 'Username harus berisikan minimal 6 karakter dan maksimal 30 karakter ...'
            },
            cekUsername: {
                errorMessage: "Username sudah dipakai ..."
            }
        },
        'password': {
            notEmpty: {
                errorMessage: 'Password harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 6,
                    max: 18
                }],
                errorMessage: 'Password harus berisikan minimal 6 karakter dan maksimal 18 karakter ...'
            }
        },
        'id_juser': {
            notEmpty: {
                errorMessage: 'Jenis User harus diisi ...'
            },
            isInt: {
                errorMessage: 'Id juser tidak valid ...'
            }
        }
    },
    edit_dosen: {
        'nm_dosen': {
            notEmpty: {
                errorMessage: 'Nama dosen Soal harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Nama dosen Soal harus berisikan minimal 1 karakter dan maksimal 100 karakter ...'
            }
        }
    },
    edit_matkul: {
        'nm_matkul': {
            notEmpty: {
                errorMessage: 'Nama matkul harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 2,
                    max: 100
                }],
                errorMessage: 'Nama matkul maksimal 100 karakter ...'
            }
        },
        'sks': {
            notEmpty: {
                errorMessage: 'SKS harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 10
                }],
                errorMessage: 'SKS tidak benar ...'
            }
        },
        'smt': {
            notEmpty: {
                errorMessage: 'Semester harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 20
                }],
                errorMessage: 'Semester tidak benar ...'
            }
        }
    },
    edit_mahasiswa: {
        'nm_mahasiswa': {
            notEmpty: {
                errorMessage: 'Nama mahasiswa harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Nama mahasiswa maksimal 100 karakter ...'
            }
        }
    },
    dosen_kuliah: {
        'kd_matkul': {
            notEmpty: {
                errorMessage: 'Matkul harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 15
                }],
                errorMessage: 'Kode matkul maksimal 100 karakter ...'
            }
        },
        'tahun_akademik': {
            notEmpty: {
                errorMessage: 'Tahun akademik harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 4,
                    max: 5
                }],
                errorMessage: 'Tahun akademik maksimal 5 karakter ...'
            }
        },
        'kelas': {
            notEmpty: {
                errorMessage: 'Kelas harus diisi ...'
            }
        }
    },
    edit_ujian: {
        'deskripsi': {
            notEmpty: {
                errorMessage: 'Deskripsi ujian harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 1,
                    max: 100
                }],
                errorMessage: 'Deskripsi ujian maksimal 100 karakter ...'
            }
        },
        'mulai': {
            notEmpty: {
                errorMessage: 'Jam mulai harus diisi ...'
            }
        },
        'selesai': {
            notEmpty: {
                errorMessage: 'Jam selesai harus diisi ...'
            }
        },
        'hari': {
            notEmpty: {
                errorMessage: 'Hari ujian harus diisi ...'
            }
        }
    },
    edit_user: {
        'password': {
            notEmpty: {
                errorMessage: 'Password harus diisi ...'
            },
            isLength: {
                options: [{
                    min: 6,
                    max: 18
                }],
                errorMessage: 'Password harus berisikan minimal 6 karakter dan maksimal 18 karakter ...'
            }
        }
    }
}
module.exports = validator;
