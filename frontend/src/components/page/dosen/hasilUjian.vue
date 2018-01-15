<template>
<div class="w3-container">
    <gen-table :exportUrl="exportUrl" :exportButton.Boolean="true" :pk="tableContent.content[0]" :formButton.Boolean="false" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="true">
    <template slot="customAction" slot-scope="ca">
            <template v-if="ca.pkData.status_ujian_peserta == 3">
                <button class="w3-button w3-small w3-red" disabled="true">Tidak Ada</button>
            </template>
            <template v-else-if="ca.pkData.status_ujian_peserta == 4">
                <router-link tag="button" :to="{name:'DcekJawaban',params:{idUjian:$route.params.idUjian,idPeserta:ca.pkData.nobp}}" class="w3-btn w3-small w3-blue">
                    <i class="fa fa-edit w3-small"></i> <b>Periksa Jawaban</b>
                </router-link>
            </template>
            <template v-else-if="ca.pkData.status_ujian_peserta == 5">
                <button class="w3-button w3-small w3-blue" disabled="true">Tidak Ada</button>
            </template>
        </template>
    </gen-table>
</div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
export default {
  name: 'hasilUjian',
  components : {
      genTable
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/hasil',
            tableContent : {
                header :  ['NOBP','Nama Mahasiswa','Kelas','Status','Nilai'],
                content : ['id','nobp','nm_mahasiswa','nm_kelas','nm_status_ujian_peserta','nilai']
            },
            exportUrl : [
            {url:'/api/ujian/'+this.$route.params.idUjian+'/hasil/cetak/excel',name:'Excel'},
            ]
        }
  }
}
</script>

<style slot-scoped>

</style>
