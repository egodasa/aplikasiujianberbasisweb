<template>

<div class="w3-container">
    <h2>Detail Kuliah</h2>
    <div id="infoKuliah" :style="!loading ? 'display:block;':'display:none;height:300px;'">
            <div class="w3-row">
                <div class="w3-col l6 s12 xs12">
                <table class="w3-table w3-border w3-bordered">
                        <tr>
                        <td class="w3-white">Nama Dosen</td>
                        <td class="w3-white">{{infoKuliah.nm_dosen}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Mata Kuliah</td>
                        <td class="w3-white">{{infoKuliah.nm_matkul}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Kelas</td>
                        <td class="w3-white">
                            {{infoKuliah.ket_nm_kelas}}</td>
                        </tr>
                        <tr>
                    <td class="w3-white">Tahun Akademik</td>
                    <td class="w3-white">{{infoKuliah.tahun_akademik}}</td>
                    </tr>
                </table>
                </div>
            </div>
    </div>
    <h2>Daftar Peserta Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :table-content="tableContent" tableType="hapus"></gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import axios from 'axios'
import _ from 'lodash'
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
import { Bus } from '../../../bus.js'

export default {
  name: 'kelolaKuliahDetail',
  components : {
      'genTable' : genTable,
      'genForm' : genForm,
      'admin' : admin
  },
  data () {
      return {
          url : 'kuliah/'+this.$route.params.idKuliah+'/mahasiswa',
          infoKuliah : {},
          tableContent : {
              header : ['NOBP','Nama Mahasiswa','Kelas'],
              content : ['id_peserta','nobp','nm_mahasiswa','nm_kelas']
          },
          loading : false,
          listForm : [
            {
                    caption : "Pilih Kelas",
                    name : "id_kelas",
                    jenis : "selectOption",
                    valueSelect : 'id_kelas',
                    captionSelect : 'nm_kelas',
                    option : []
                },
            {
                    caption : "Tambahkan Mahasiswa",
                    name : "nobp",
                    jenis : "selectize",
                    labelField : 'nm_mahasiswa',
                    valueField : 'nobp',
                    options : [],
                    placeholder : "Ketik nobp atau nama mahasiswa ....",
                    searchField : ['nm_mahasiswa','nobp'],
                    maxItems : null,
                    load : (q,c)=>{
                        if(q.length <= 1) return c()
                        let query = `query mahasiswaNotInKelasKuliah($id_kuliah : String,$nobp : String,$nm_mahasiswa:String) {mahasiswaNotInKelasKuliah(id_kuliah : $id_kuliah,nobp : $nobp,nm_mahasiswa : $nm_mahasiswa){nobp,nm_mahasiswa}}`
                        let kueri = {query:query, variables : {id_kuliah : this.$route.params.idKuliah   ,nobp:q,nm_mahasiswa:q}}
                        console.log(kueri)
                        axios.post('api/v2/mahasiswa',kueri)
                            .then(res=>{
                                console.log(res.data.data)
                                c(res.data.data.mahasiswaNotInKelasKuliah)
                                })
                            .catch(err=>{
                                c()
                                })
                        },
                    render : {
                        option : function(item,escape){
                                return '<div>'+escape(item.nobp)+' - '+escape(item.nm_mahasiswa)+'</div>'
                            },
                        item : function(item,escape){
                                return '<div>'+escape(item.nobp)+' - '+escape(item.nm_mahasiswa)+'</div>'
                            }
                    }
                }
                
            ]
        }
    },
  created (){
      this.detailKuliah()
  },
  methods : {
      changeTabs (x){
          this.currentTabs = x
      },
      detailKuliah () {
          axios.get('api/kuliah/'+this.$route.params.idKuliah)
            .then(res=>{
                this.infoKuliah = res.data.data[0]
                _.forEach(this.infoKuliah.id_kelas,(v,k)=>{
                    this.listForm[0].option.push({id_kelas:v,nm_kelas:this.infoKuliah.nm_kelas[k]})
                })
                })
            .catch(err=>{
                Bus.$emit('showAlert','Pesan!','Tidak dapat mengambil detail kuliah. Silahkan muat ulang halaman!','warning')
                this.infoKuliah = [{}]
                })
      }
  }
}
</script>

<style scoped>

</style>
