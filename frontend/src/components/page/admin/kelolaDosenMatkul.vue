<template>
    
<div class="w3-container">
    <h2>Daftar Dosen Pengampu</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <label>Pilih Mata Kuliah</label>
        <span class="w3-container">
        <v-select v-model="matkul" multiple :options="listMatkul" label="nm_matkul"></v-select>
        </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" tableType="hapus" :url="url" :tableContent="tableContent">
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaDosenMatkul',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'dosen/'+this.$route.params.nidn+'/matkul',
          tableContent : {
            header :  ['Kode MK','Nama Matkul'],
            content : ['id_mdosen','kd_matkul','nm_matkul']
            },
          matkul : null,
          listMatkul : []
        }
    },
    created () {
        this.getListMatkul()
    },
    methods : {
        submitData (){
            var tmp = []
            _.forEach(this.matkul, (v,k)=>{
                tmp.push({id_mdosen:this.$route.params.nidn+""+v.kd_matkul ,nidn:this.$route.params.nidn,kd_matkul:v.kd_matkul})
                })
            ajx.post('api/'+this.url,tmp)
            .then(res=>{
                bus.$emit('toggleFormData')
                bus.$emit('newData')
                this.matkul = null
                })
            .catch(err=>{
                console.log(err)
                })
            
        },
        getListMatkul () {
            ajx.get('api/matkul')
            .then(res=>{
                this.listMatkul = res.data.data
                })
            .catch(err=>{
                })
        },
        toggleFormData() {
            bus.$emit('toggleFormData')
        }
    }
}
</script>

<style scoped>

</style>
