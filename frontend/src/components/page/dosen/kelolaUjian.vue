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
                <router-link :to="{name:'DkelolaUjianDetail',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import dosen from './halamanDosen.vue'
import Datepicker from 'vuejs-datepicker';

export default {
  name: 'kelolaUjian',
  components : {
      genTable, genForm, dosen, Datepicker
  },
  data () {
      return {
          url : 'dosen/'+this.$session.get('user').username+'/ujian',
            tableContent : {
                header :  ['Matkul','Jenis Ujian','Waktu Pelaksanaan','Status','TA'],
                content : ['id_ujian','nm_matkul','nm_jujian','ket_waktu','nm_status_ujian','tahun_akademik']
            },
          listForm : [
                {
                    caption : "Pilih Kuliah",
                    name : "id_kuliah",
                    jenis : "selectize",
                    labelField : 'nm_matkul',
                    valueField : 'id_kuliah',
                    options : [],
                    placeholder : "Ketik nama mata kuliah",
                    searchField : ['nm_matkul','nm_dosen'],
                    render : {
                        option : function(item,escape){
                                return '<div>'+escape(item.nm_matkul + '('+item.tahun_akademik+')') + '<br/>'+escape(item.nm_dosen) + '<br/>'+escape(item.ket_nm_kelas)+'</div>'
                            },
                        item : function(item,escape){
                                return '<div>'+escape(item.nm_matkul) + ' - '+escape(item.nm_dosen) +'</div>'
                            }
                    },
                    onItemAdd : (value, $item)=>{
                        this.getDataSelectGraph('api/v2/jenis_ujian',{
                          query : `query jenisUjianTersedia($id_kuliah : String) {jenisUjianTersedia(id_kuliah : $id_kuliah){id_jujian,nm_jujian}}`,
                          variables : {id_kuliah : value}
                          },'jenisUjianTersedia',1,'jenis ujian','select')
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
      this.getDataSelectGraph('api/v2/dosen',{
          query : `query getKuliah($nidn : String){ getKuliah(nidn : $nidn){id_kuliah,nm_matkul,nm_dosen,tahun_akademik,ket_nm_kelas}}`,
          variables : {nidn : this.$route.params.nidn}
          },'getKuliah',0,'kuliah','selectize')
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
        getDataSelectGraph (url,query,name,index,nama,tipe){
            this.$ajx.post(url,query)
                .then(res=>{
                    if(tipe == 'selectize'){
                        this.listForm[index].options = res.data.data[name]
                    }else{
                        this.listForm[index].option = res.data.data[name]
                    }
                    })
                .catch(err=>{
                    bus.$emit('showAlert','Pesan!','Tidak dapat mengambil daftar '+nama+'. Silahkan muat ulang halaman','warning')
                    this.listForm[index].options = []
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
