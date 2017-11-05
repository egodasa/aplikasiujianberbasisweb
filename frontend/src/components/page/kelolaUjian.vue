<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Ujian</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :url="url" :tableContent="tableContent">
        <template slot="customAction" scope="ca">
            <router-link :to="{name:'kelolaPesertaUjian',params:{idUjian:ca.pkData}}" class="w3-btn w3-small w3-blue"><i class="fa fa-edit w3-small"></i> <b>Kelola Peserta</b></router-link>
            <router-link :to="{name:'kelolaSoalUjian',params:{idUjian:ca.pkData}}" class="w3-btn w3-small w3-blue-gray"><i class="fa fa-edit w3-small"></i> <b>Kelola Soal</b></router-link>
            <router-link :to="{name:'hasilUjian',params:{idUjian:ca.pkData}}" class="w3-btn w3-small w3-teal"><i class="fa fa-edit w3-small"></i> <b>Hasil Ujian</b></router-link>
        </template>
    </gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'
import axios from 'axios'

export default {
  name: 'kelolaUjian',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'ujian',
            listForm : [
				{
					caption: "Jam",
					name:"jam",
					jenis:"textField",
					tipe:"number",
					value:null,
					min:0,
					max:60
					},
				{
					caption: "Menit",
					name:"menit",
					jenis:"textField",
					tipe:"number",
					value:null ,
					min:0,
					max:60
					},
				{
					caption: "Tipe Soal Ujian",
					name:"id_tsoal",
					jenis:"radioButton",
					tipe:"text",
					value:null,
                    valueSelect : "id_tsoal",
                    captionSelect : "nm_tipe"
					},
				{
					caption: "Jenis Ujian",
					name:"id_jujian",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_jujian",
                    captionSelect : "nm_jenis",
					},
				{
					caption: "Mata Kuliah",
					name:"id_matkul",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_matkul",
                    captionSelect : "nm_matkul",
					}
			],
            tableContent : {
                header :  ['Nama Ujian','Jam','Menit','Banyak Peserta','Banyak Soal','Tipe Ujian'],
                content : ['id','nm_ujian','jam','menit','banyak_peserta','banyak_soal','tipe_soal']
            }
        }
  },
  created () {
      this.getDataTipeSoal()
  },
  methods : {
        getDataTipeSoal () {
            axios.get('api/tipe_soal')
                .then(res=>{
                    this.listForm[3].option = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        }
  }
}
</script>

<style scoped>

</style>
