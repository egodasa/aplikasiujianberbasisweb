export const dosenConf = {
    data () {
        return {
            dosenMenu : [
            {
              path : '/dosen/'+this.$session.get('user').username,
              name : 'Beranda',
              icon : 'fa-home fa-fw',
              key : 1
              },
            {
              path : '/dosen/'+this.$session.get('user').username+'/ujian',
              name : 'Daftar Ujian',
              icon : 'fa-list-alt fa-fw',
              key : 2
            },
            {
              path : '/dosen/'+this.$session.get('user').username+'/kuliah',
              name : 'Daftar Kuliah',
              icon : 'fa-list-alt fa-fw',
              key : 3
            }
            ]
        }
    }
}
