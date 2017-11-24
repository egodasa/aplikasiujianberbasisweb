<template>
<div class="w3-container">
    <gen-table :pk="tableContent.content[0]" :refreshButton.Boolean="false" :formButton.Boolean="false" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="false"></gen-table>
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
                header :  ['NOBP','Nama Mahasiswa','Nilai'],
                content : ['id_hasil','nobp','nm_mahasiswa','nilai']
            }
        }
  }
}
</script>

<style scoped>

</style>
