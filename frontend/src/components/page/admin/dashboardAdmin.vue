<template>
    <div>
    <header class="w3-container" style="padding-top:22px">
    <h2><i class="fa fa-home"></i> Beranda</h2>
    </header>
    <div class="w3-row-padding w3-margin-bottom" >
    <div class="w3-quarter">
      <div class="w3-container w3-red w3-padding-16">
        <div class="w3-left"><i class="fa fa-list-alt w3-xxxlarge"></i></div>
        <div class="w3-right">
          <h3>{{statistik.total_ujian}}</h3>
        </div>
        <div class="w3-clear"></div>
        <h4>Total Ujian</h4>
      </div>
    </div>
    <div class="w3-quarter">
      <div class="w3-container w3-blue w3-padding-16">
        <div class="w3-left"><i class="fa fa-institution w3-xxxlarge"></i></div>
        <div class="w3-right">
          <h3>{{statistik.total_kuliah}}</h3>
        </div>
        <div class="w3-clear"></div>
        <h4>Total Kuliah</h4>
      </div>
    </div>
    <div class="w3-quarter">
      <div class="w3-container w3-teal w3-padding-16">
        <div class="w3-left"><i class="fa fa-user-md w3-xxxlarge"></i></div>
        <div class="w3-right">
          <h3>{{statistik.total_dosen}}</h3>
        </div>
        <div class="w3-clear"></div>
        <h4>Total Dosen</h4>
      </div>
    </div>
    <div class="w3-quarter">
      <div class="w3-container w3-orange w3-text-white w3-padding-16">
        <div class="w3-left"><i class="fa fa-users w3-xxxlarge"></i></div>
        <div class="w3-right">
          <h3>{{statistik.total_mahasiswa}}</h3>
        </div>
        <div class="w3-clear"></div>
        <h4>Total Mahasiswa</h4>
      </div>
    </div>
    <div class="w3-col xs12 l12 md12">
    <header style="padding-top:22px">
    <h2><i class="fa fa-list"></i> Daftar Nilai</h2>
    </header>
    <gen-table :aksi.Boolean="false" :refreshButton.Boolean="false" :exportUrl="exportUrl" :exportButton.Boolean="false" :pk="tableContent[0].name" :formButton.Boolean="false" :url="url" :tableContent="tableContent" tableType="lain"></gen-table>
    </div>
  </div>
  </div>
  </div>

</template>

<script>

import genTable from '../../template/GenTable.vue'

export default {
  name: 'dashboardAdmin',
  components : {
      genTable
  },
  data () {
    return {
      statistik : {
          total_dosen : 0,
          total_ujian : 0,
          total_kuliah : 0,
          total_mahasiswa : 0
          },
    url : 'ujian/nilai/rata',
    tableContent : [
          {name:'id_ujian',show:false,caption:"ID Ujian"},
          {name:'nm_matkul',show:true,caption:"Ujian"},
          {name:'nm_dosen',show:true,caption:"Dosen"},
          {name:'nm_jujian',show:true,caption:'Jenis'},
          {name:'avg',show:true,caption:"Rata-rata"}
          ]
    }
},
  methods : {
      getStatistik () {
            let query = `query{
              statistik {
                total_ujian
                total_kuliah
                total_dosen
                total_mahasiswa
              }
            }`
            let kueri = {query:query}
            this.$ajx.post('api/v2/statistik',kueri)
            .then(res=>{
                
                this.statistik = res.data.data.statistik[0]
                })
            .catch(err=>{
                
                })
      }
  },
  created () {
      this.getStatistik()
  }
}
</script>

<style scoped>

</style>
