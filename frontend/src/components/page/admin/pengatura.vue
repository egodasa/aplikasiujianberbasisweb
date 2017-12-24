<template>
    <div class="w3-container">
        <h2>Pengaturan</h2>
        <span class="w3-container">
                <label>Tahun Akademik</label>
                <input type="text" class="w3-input w3-border" v-model="tahun" />
            </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

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
                header :  ['NOBP','Nama','Kelas'],
                content : ['id_mahasiswa','nobp','nm_mahasiswa','nm_kelas']
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
                bus.$emit('toggleFormData')
                bus.$emit('newData')
                this.mahasiswa = null,
                this.id_kelas = null
                })
            .catch(err=>{
                console.log(err)
                })
            
        },
        getDataSelect (x,y,name,args) {
            let query = `query mahasiswaNotInKelasUjian($id_ujian : String) {mahasiswaNotInKelasUjian(id_ujian : $id_ujian){nobp,nm_mahasiswa}}`
            let kueri = {query:query, variables : {id_ujian : this.$route.params.idUjian}}
            console.log(kueri)
            this.$ajx.post('api/v2/'+x,kueri)
                .then(res=>{
                    this[y] = res.data.data[name]
                    })
                .catch((err)=>{
                    console.log(err)
                    this[y] = []
                    })
        },
        toggleFormData() {
            bus.$emit('toggleFormData')
        },
        getKelas (x) {
            this.listKelas = x
        }
  }
}
</script>

<style scoped>

</style>
