<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Soal Ujian</h2>
    </div>
    <button type="button" @click="toggleFormData()" class="w3-button w3-blue">Tambah Data</button>
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content w3-animate-top">
        <div class="w3-card-8 w3-container w3-section" >
        <span @click="toggleFormData()" class="w3-closebtn">&times;</span>
            <h3>Tambah Soal Ujian</h3>
            <gen-table :url="url+'?belumDitambahkan=ya'" :header="addTableHeader" tableType="list">
            cdcd
            </gen-table>
        </div>
        </div>
    </div>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'

export default {
  name: 'kelolaSoalUjian',
  components : {
      genTable
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/soal',
          tableHeader : ['Isi soal','Jawaban','Tipe Soal'],
          addTableHeader : ['Isi soal','Jawaban','Tipe Soal'],
          showForm : false
        }
  },
  methods : {
      toggleFormData () {
           this.showForm = !this.showForm
        }
  }
}
</script>

<style scoped>

</style>
