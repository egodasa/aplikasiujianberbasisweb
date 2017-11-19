<template>
<admin>
<div class="w3-container">
    <h2>Kelola Ujian</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="edit_hapus">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Daftar Soal">
                <router-link :to="{name:'kelolaSoalUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-list-alt "></i></router-link>
            </span>
            <span class="hint--top" aria-label="Periksa Ujian">
                <router-link :to="{name:'jawabanUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white" v-if="ca.pkData.id_jsoal == 2 ? true : false"><i class="fa fa-check-square-o "></i></router-link>
            </span>
            <span class="hint--top" aria-label="Hasil Ujian">
                <router-link :to="{name:'hasilUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white" ><i class="fa fa-list-ol "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import axios from 'axios'
export default {
  name: 'kelolaUjian',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'ujian',
            listForm : [
				{
					caption: "Tipe Soal Ujian",
					name:"id_jsoal",
					jenis:"radioButton",
					tipe:"text",
					value:null,
                    valueSelect : "id_jsoal",
                    captionSelect : "jsoal"
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
                    captionSelect : "nm_jujian",
					},
                {
					caption: "Jam Mulai",
					name:"mulai",
					jenis:"textField",
					tipe:"selectOption",
					value:null,
					min:0,
					max:60
					},
				{
					caption: "Jam Selesai",
					name:"selesai",
					jenis:"textField",
					tipe:"selectOption",
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
                content : ['id_ujian','nm_matkul','nm_jujian','nm_kelas','nm_jsoal']
            }
        }
  },
  created () {
      this.getDataSelect('kuliah',1)
      this.getDataSelect('jenis_soal',0)
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
