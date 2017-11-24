<template>
<div class="w3-container">
    <gen-table :pk="tableContent.content[0]" :refreshButton.Boolean="false" :formButton.Boolean="false" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="false"></gen-table>
</div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
export default {
  name: 'kelolaPesertaUjian',
  components : {
      genTable
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/mahasiswa',
            tableContent : {
                header :  ['NOBP','Nama Mahasiswa'],
                content : ['id_ujian','nobp','nm_mahasiswa']
            }
        }
  }
}
</script>

<style scoped>

</style>
