<template>
    
<div class="w3-container">
    <h2>Daftar Mahasiswa</h2>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :tableContent="tableContent">
    <template slot="customButton">
        <div class="w3-modal" :style="showFormUpload ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content">
        <div class="w3-card-8 w3-container w3-section">
        <form name="addData" method="POST" enctype="multipart/form-data">
            <h2>Unggah Data Mahasiswa</h2>
             <label>Ketentuan file yang akan diunggah :</label>
             <ol>
                <li>Pastikan tidak ada NOBP atau data mahasiswa yang duplikat atau sama.</li>
                <li>File yang dapat diunggah adalah file excel (xls,xlsx) atau csv (.csv)</li>
                <li>Pastikan isi file hanyalah nobp dan nama mahasiswa. Dimana nobp berada pada kolom pertama (Kolom A) dan nama mahasiswa berada pada Kolom kedua (Kolom B)</li>
                <li>Jika perihal diatas sudah dipahami, silahkan unggah data mahasiswa pada form dibawah :</li>
             </ol>
             <div class="w3-container">
             <label>File Data Mahasiswa :</label>
             <input type="file" class="w3-input w3-border" />
             </div>
             <div class="w3-container">
             <button type="submit" class="w3-button w3-blue w3-section">Unggah</button>
             <button type="button" class="w3-button w3-red w3-section" @click="toggleFormUpload()">Batal</button>
             </div>
        </form>
        </div>
        </div>
        </div>
        <button @click="toggleFormUpload()" type="button" v-if="false" class="w3-button w3-blue w3-hover-blue-grey w3-small"><b><i class="fa fa-plus"></i> Unggah Data Mahasiswa</b></button>
    </template>
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'

import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaMahasiswa',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'mahasiswa',
            listForm : [
                {
					caption: "Nama Mahasiswa",
					name:"nm_mahasiswa",
					jenis:"textField",
					tipe:"text",
					value:null,
                    error : null
					},
                {
					caption: "NOBP",
					name:"nobp",
					jenis:"textField",
					tipe:"text",
                    min:14,
                    max:14,
					value:null,
                    error : null
					}
                    
			],
            tableContent : [
                {name:"id_mahasiswa",show:false,caption:null},
                {name:"nm_mahasiswa",show:true,caption:"Nama"},
                {name:"nobp",show:true,caption:"NOBP"}
            ],
            showFormUpload : false
        }
  },
  methods : {
      toggleFormUpload (){
          this.showFormUpload = !this.showFormUpload
      }
  }
}
</script>

<style scoped>

</style>
