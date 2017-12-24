<template>

<div class="w3-container">
    <h2>Kelola Ujian</h2>
    <i>* Status ujian akan aktif jika terdapat minimal 1 soal pada ujian tersebut.</i>
    <div class="w3-border"></div>
    <br/>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="edit_hapus">
        <template slot="customAction" slot-scope="ca">
            <span class="hint--top" aria-label="Kelola Ujian">
                <router-link :to="{name:'kelolaUjianDetail',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import Datepicker from 'vuejs-datepicker';

export default {
  name: 'kelolaUjian',
  components : {
      genTable, genForm, admin, Datepicker
  },
  data () {
      return {
          url : 'ujian',
            tableContent : {
                header :  ['Matkul','Dosen','Jenis Ujian','Waktu Pelaksanaan','Status','TA'],
                content : ['id_ujian','nm_matkul','nm_dosen','nm_jujian','ket_waktu','nm_status_ujian','tahun_akademik']
            },
          listForm : [
                {
                    caption : "Pilih Kuliah",
                    name : "id_kuliah",
                    jenis : "selectize",
                    labelField : 'nm_matkul',
                    valueField : 'id_kuliah',
                    options : [],
                    placeholder : "Ketik nama dosen atau matkul",
                    searchField : ['nm_matkul','nm_dosen'],
                    load : (q,c)=>{
                        if(q.length <= 1) return c()
                        var query = `query cariKuliah($cari : String){ cariKuliah(cari : $cari){id_kuliah,nm_matkul,nm_dosen,tahun_akademik,ket_nm_kelas}}`
                        var kueri = {query : query,variables : {cari : q}}
                        this.$ajx.post('api/v2/kuliah',kueri)
                            .then(res=>{
                                c(res.data.data.cariKuliah)
                                })
                            .catch(res=>{
                                c()
                                })
                        },
                    render : {
                        option : function(item,escape){
                                return '<div>'+escape(item.nm_matkul + '('+item.tahun_akademik+')') + '<br/>'+escape(item.nm_dosen) + '<br/>'+escape(item.ket_nm_kelas)+'</div>'
                            },
                        item : function(item,escape){
                                return '<div>'+escape(item.nm_matkul) + ' - '+escape(item.nm_dosen) +'</div>'
                            }
                    },
                    onItemAdd : (value, $item)=>{
                        let query = `query jenisUjianTersedia($id_kuliah : String) {jenisUjianTersedia(id_kuliah : $id_kuliah){id_jujian,nm_jujian}}`
                        let kueri = {query:query, variables : {id_kuliah : value}}
                        this.$ajx.post('api/v2/jenis_ujian',kueri)
                        .then(res=>{
                            this.listForm[1].option = res.data.data['jenisUjianTersedia']
                            })
                        .catch(err=>{
                            console.log(err)
                            })
                        },
                    onFocus : ()=>{
                        if(this.listForm[1].option.length > 0) this.listForm[1].option = []
                        }
                },
                {
                    caption : "Pilih Jenis Ujian",
                    name : "id_jujian",
                    jenis : "selectOption",
                    valueSelect : 'id_jujian',
                    captionSelect : 'nm_jujian',
                    option : []
                },
                {
                    caption : "Pilih Jenis Soal",
                    name : "id_jsoal",
                    jenis : "selectOption",
                    valueSelect : 'id_jsoal',
                    captionSelect : 'nm_jsoal',
                    option : []
                },
                {
                    caption : "Hari Ujian",
                    name : "hari",
                    jenis : "datePick"
                },
                {
                    caption : "Jam Mulai",
                    name : "mulai",
                    jenis : "textField",
                    tipe:'text'
                },
                {
                    caption : "Jam Selesai",
                    name : "selesai",
                    jenis : "textField",
                    tipe:'text'
                },
                {
                    caption : "Deskripsi",
                    name : "deskripsi",
                    jenis : "textArea"
                }
          ]
        }
  },
  created () {
      this.getDataSelect('api/jenis_soal',2)
  },
  methods : {
        getDataSelect (url,index){
            this.$ajx.get(url)
                .then(res=>{
                    this.listForm[index].option = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        },
        toggleFormData() {
            bus.$emit('toggleFormData')
            this.resetData()
            this.edit = false
        }
  }
}
</script>

<style scoped>
</style>
