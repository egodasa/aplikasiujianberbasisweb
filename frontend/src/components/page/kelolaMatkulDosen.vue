<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Dosen Pengampu</h2>
    </div>
    <button type="button" @click="toggleFormData()" class="w3-button w3-blue">Tambah Data</button>
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content w3-animate-top">
        <div class="w3-card-8 w3-container w3-section" >
        <span @click="toggleFormData()" class="w3-closebtn">&times;</span>
            <h3>Tambah Dosen</h3>
            <gen-table :pk="tableContentAdd.content[0]" :url="url" urlQuery="&belumDitambahkan=ya" :tableContent="tableContentAdd" tableType="tambahkan"></gen-table>
        </div>
        </div>
    </div>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="hapus">
        <template slot="customAction" scope="ca">
            <router-link :to="{name:'kelolaMatkulDosenMahasiswa',params:{idMatkulDosen:ca.pkData}}" class="w3-btn w3-small w3-blue"><i class="fa fa-edit w3-small"></i> <b>Daftar Mahasiswa</b></router-link>
        </template>
    </gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import { Bus } from '../../bus.js';
import axios from 'axios';

export default {
  name: 'kelolaMatkulDosen',
  components : {
      genTable
  },
  data () {
      return {
          url : 'matkul/'+this.$route.params.idMatkul+'/dosen',
          tableContent : {
                header :  ['Nama Dosen'],
                content : ['id_mdosen','nm_dosen']
            },
          tableContentAdd : {
                header :  ['Nama Dosen'],
                content : ['id_dosen','nm_dosen']
          },
          showForm : false
        }
  },
  created () {
      Bus.$on('addDataList', (x)=>{
          this.addData(x)
          })
  },
  methods : {
    toggleFormData () {
           this.showForm = !this.showForm
        },
    addData (id) {
            console.log('adddata run')
            var data = {id_dosen : id,id_matkul:this.$route.params.idMatkul}
            console.log(data)
            axios({
				method : 'POST',
				url :'api/'+this.url,
                data : data
				})
			.then(res=>{
                if(res.data.status == true) {
                    this.toggleFormData()
                    Bus.$emit('newData')
                }
                else console.log(res.data.error)
			})
			.catch(err=>{
				console.log(err)
			})
        }
  },
  deactivated () {
      console.log('non aktif')
  },
  destroyed () {
      Bus.$off('addDataList')
  }
}
</script>

<style scoped>

</style>
