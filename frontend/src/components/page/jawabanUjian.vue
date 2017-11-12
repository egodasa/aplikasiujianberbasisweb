<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Mahasiswa</h2>
    </div>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain">
        <template slot="customAction" scope="ca">
            <router-link tag="button" :disabled="!ca.pkData.status" :to="{name:'cekJawaban',params:{idUjian:$route.params.idUjian,idPeserta:ca.pkData.id_mahasiswa}}" :class="ca.pkData.status ? 'w3-btn w3-small w3-blue' : 'w3-btn w3-small w3-red'"><i class="fa fa-edit w3-small"></i> <b>{{ca.pkData.status ? 'Periksa Jawaban' : 'Jawaban Kosong'}}</b></router-link>
        </template>
    </gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import axios from 'axios'

export default {
  name: 'jawabanUjian',
  components : {
      genTable
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/jawaban',
            tableContent : {
                header :  ['NOBP','Nama',],
                content : ['id_mahasiswa','nobp','nm_mahasiswa']
            }
        }
  },
  created () {

  },
  methods : {
        
  }
}
</script>

<style scoped>

</style>
