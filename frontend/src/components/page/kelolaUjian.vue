<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Ujian</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="edit_hapus">
        <template slot="customAction" scope="ca">
            <router-link :to="{name:'kelolaSoalUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-btn w3-small w3-blue"><i class="fa fa-edit w3-small"></i> <b>Daftar Soal</b></router-link>
            <router-link :to="{name:'jawabanUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-btn w3-small w3-blue" v-if="ca.pkData.id_tsoal == 2 ? true : false"><i class="fa fa-edit w3-small"></i> <b>Periksa Jawaban</b></router-link>
            <router-link :to="{name:'hasilUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-btn w3-small w3-blue" v-if="ca.pkData.id_tsoal == 1 ? true : false"><i class="fa fa-edit w3-small"></i> <b>Hasil Ujian</b></router-link>
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
					caption: "Tipe Soal Ujian",
					name:"id_tsoal",
					jenis:"radioButton",
					tipe:"text",
					value:null,
                    valueSelect : "id_tsoal",
                    captionSelect : "nm_tipe"
					},
                {
					caption: "Mata Kuliah",
					name:"id_kuliah",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_kuliah",
                    captionSelect : "nm_matkul"
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
					caption: "Detail Ujian",
					name:"deskripsi",
					jenis:"textField",
					tipe:"text",
					value:null ,
					min:0,
					max:60
					}
			],
            tableContent : {
                header :  ['Matkul','Jenis','Kelas','Tipe Ujian'],
                content : ['id_ujian','nm_matkul','nm_jenis','nm_kelas','nm_tipe']
            }
        }
  },
  created () {
      this.getDataSelect('kuliah',1)
      this.getDataSelect('tipe_soal',0)
      this.getDataSelect('jenis_ujian',2)
  },
  methods : {
        getDataSelect (x,y) {
            axios.get('api/'+x)
                .then(res=>{
                    this.listForm[y].option = res.data.data
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
