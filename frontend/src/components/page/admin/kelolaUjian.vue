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
					caption: "Mata Kuliah",
					name:"id_kuliah",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_kuliah",
                    captionSelect : "captionSelect"
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
					caption: "Jenis Soal Ujian",
					name:"id_jsoal",
					jenis:"radioButton",
					tipe:"text",
					value:null,
                    valueSelect : "id_jsoal",
                    captionSelect : "nm_jsoal"
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
      this.getDataKuliah('kuliah',0)
      this.getDataSelect('jenis_ujian',1)
      this.getDataSelect('jenis_soal',2)
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
        },
        getDataKuliah () {
            axios.get('api/kuliah')
                .then(res=>{
                    this.listForm[0].option = res.data.data
                    _.forEach(this.listForm[0].option, (v,k)=>{
                        v.captionSelect = v.nm_dosen +' - '+ v.nm_matkul + ' - ' + v.nm_kelas
                        })
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
