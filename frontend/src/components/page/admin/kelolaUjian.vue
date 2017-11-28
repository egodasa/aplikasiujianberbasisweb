<template>
<admin>
<div class="w3-container">
    <h2>Kelola Ujian</h2>
    <div class="w3-border"></div>
    <br/>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="edit_hapus">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Kelola Ujian">
                <router-link :to="{name:'kelolaUjianDetail',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
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
import _ from 'lodash'
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
					caption: "Pilih Mata Kuliah",
					name:"kd_matkul",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "kd_matkul",
                    captionSelect : "nm_matkul",
                    option : []
					},
                    {
					caption: "Pilih Dosen",
					name:"nidn",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "nidn",
                    captionSelect : "nm_dosen",
                    option : []
					},
                    {
					caption: "Jenis Ujian",
					name:"id_jujian",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_jujian",
                    captionSelect : "nm_jujian",
                    option : []
					},
                    {
					caption: "Jenis Soal Ujian",
					name:"id_jsoal",
					jenis:"radioButton",
					tipe:"text",
					value:null,
                    valueSelect : "id_jsoal",
                    captionSelect : "nm_jsoal",
                    option : []
					},
                    {
					caption: "Waktu Ujian",
					name:"hari",
					jenis:"datePick",
					tipe:"text",
					value : function (){
                        return new Date('now')
                        }
					},
                    {
					caption: "Jam Mulai",
					name:"mulai",
					jenis:"textField",
					tipe:"text",
					value:"12:00",
					},
                    {
					caption: "Jam Berakhir",
					name:"selesai",
					jenis:"textField",
					tipe:"text",
					value:"14:00",
					},
                    {
					caption: "Tahun Akademik",
					name:"tahun_akademik",
					jenis:"textField",
					tipe:"text",
					value:null,
					},
                    {
					caption: "Kelas",
					name:"id_kelas",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_kelas",
                    captionSelect : "nm_kelas",
                    option : []
					},
                    {
					caption: "Keterangan Ujian",
					name:"deskripsi",
					jenis:"textArea",
					tipe:"text"
					}
			],
            tableContent : {
                header :  ['Matkul','Kelas',],
                content : ['id_ujian','nm_matkul','nm_kelas']
            }
        }
  },
  created () {
      this.getDataSelect('dosen',1)
      this.getDataSelect('matkul',0)
      this.getDataSelect('kelas',8)
      this.getDataSelect('jenis_ujian',2)
      this.getDataSelect('jenis_soal',3)
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
