export const adminConf = {
    data () {
        return {
            adminMenu : [
              {
              path : '/',
              name : 'Beranda',
              icon : 'fa-home fa-fw',
              key : 1
              },
              {
                  path : '/admin/ujian',
                  name : 'Ujian',
              icon : 'fa-list-alt fa-fw',
              key : 2
              },
              {
                  path : '/admin/mahasiswa',
                  name : 'Mahasiswa',
              icon : 'fa-users fa-fw',
              key : 3
              },
              {
                  path : '/admin/soal',
                  name : 'Bank Soal',
              icon : 'fa-folder-o fa-fw',
              key : 4
              },
              {
                  path : '/admin/kelas',
                  name : 'Kelas',
              icon : 'fa-book fa-fw',
              key : 5
              },
              {
                  path : '/admin/matkul',
                  name : 'Matkul',
              icon : 'fa-book fa-fw',
              key : 6
              },
              {
                  path : '/admin/tipe-soal',
                  name : 'Tipe Soal',
              icon : 'fa-book fa-fw',
              key : 7
              },
              {
                  path : '/admin/jenis-ujian',
                  name : 'Jenis Ujian',
              icon : 'fa-book fa-fw',
              key : 8
              },
              {
                  path : '/admin/dosen',
                  name : 'Dosen',
              icon : 'fa-user-md fa-fw',
              key : 9
              },
              {
                  path : '/admin/kuliah',
                  name : 'Kuliah',
              icon : 'fa-institution fa-fw',
              key : 10
              }
         //     {
        //          path : '/ujian/login',
       //           name : 'Login Peserta Ujian',
       //       icon : 'fa-eye fa-fw'
       //       },
             // {
       //           path : '/ujian/petunjuk',
         //         name : 'Petunjuk Ujian',
           //   icon : 'fa-eye fa-fw'
          //    },
          //    {
          //        path : '/ujian/soal',
          //        name : 'LJK Ujian',
          //    icon : 'fa-book fa-fw'
          //    }
            ]
        }
    }
}
