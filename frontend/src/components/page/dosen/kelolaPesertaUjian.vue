<template>
    <div class="w3-container">
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <span class="w3-container">
            <label>Pilih Kelas</label>
            <select class="w3-select w3-border" v-model="id_kelas" @change="getDataSelect('mahasiswa','listMahasiswa','mahasiswaNotInKelasUjian',{id_ujian:$route.params.idUjian})">
                <option v-for='x in listKelas' :value="x.id_kelas">{{x.nm_kelas}}</option>
            </select>
        </span>
        <span class="w3-container">
        <label>Pilih Mahasiswa</label>
        <v-select v-model="mahasiswa" multiple :options="listMahasiswa" label="nm_mahasiswa"></v-select>
        </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain">
        <template slot="customAction" slot-scope="ca">
            <template v-if="ca.pkData.status_ujian_peserta == 3">
                <button class="w3-button w3-small w3-red" disabled="true">Tidak Ada</button>
            </template>
            <template v-else-if="ca.pkData.status_ujian_peserta == 4">
                <router-link tag="button" :to="{name:'cekJawaban',params:{idUjian:$route.params.idUjian,idPeserta:ca.pkData.nobp}}" class="w3-btn w3-small w3-blue">
                    <i class="fa fa-edit w3-small"></i> <b>Periksa Jawaban</b>
                </router-link>
            </template>
            <template v-else-if="ca.pkData.status_ujian_peserta == 5">
                <button class="w3-button w3-small w3-blue" disabled="true">Tidak Ada</button>
            </template>
        </template>
    </gen-table>
    </div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import dosen from './halamanDosen.vue'

export default {
  name: 'kelolaPesertaUjian',
  components : {
      genTable, genForm
  },
  props : {
      infoUjian : {
          required : true,
          type : Object,
          default : function(){
              return {}
          }
      }
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/mahasiswa',
            tableContent : {
                header :  ['NOBP','Nama','Kelas','Status Peserta','Status Ujian'],
                content : ['id_mahasiswa','nobp','nm_mahasiswa','nm_kelas','nm_status_peserta','nm_status_upeserta']
            },
            mahasiswa : null,
            id_kelas : null,
            listMahasiswa : [],
            listKelas : []
        }
  },
  created () {
        this.getKelas(this.infoUjian.kelas)
  },
  methods : {
        submitData (){
            var tmp = []
            _.forEach(this.mahasiswa, (v,k)=>{
                tmp.push({id_peserta:v.nobp+'-'+this.$route.params.idUjian,id_ujian:this.$route.params.idUjian,nobp:v.nobp,id_kelas:this.id_kelas})
                })
            this.$ajx.post('api/'+this.url,tmp)
            .then(res=>{
                Bus.$emit('toggleFormData')
                Bus.$emit('newData')
                this.mahasiswa = null,
                this.id_kelas = null
                })
            .catch(err=>{
                
                })
            
        },
        getDataSelect (x,y,name,args) {
            let query = `query mahasiswaNotInKelasUjian($id_ujian : String) {mahasiswaNotInKelasUjian(id_ujian : $id_ujian){nobp,nm_mahasiswa}}`
            let kueri = {query:query, variables : {id_ujian : this.$route.params.idUjian}}
            
            this.$ajx.post('api/v2/'+x,kueri)
                .then(res=>{
                    this[y] = res.data.data[name]
                    })
                .catch((err)=>{
                    
                    this[y] = []
                    })
        },
        toggleFormData() {
            Bus.$emit('toggleFormData')
        },
        getKelas (x) {
            this.listKelas = x
        }
  }
}
</script>

<style slot-scoped>

</style>
