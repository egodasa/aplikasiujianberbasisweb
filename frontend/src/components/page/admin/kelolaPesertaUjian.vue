<template>
    <admin>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Peserta Ujian</h2>
    </div>
    <button type="button" @click="toggleFormData()" class="w3-button w3-blue">Tambah Data</button>
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content w3-animate-top">
        <div class="w3-card-8 w3-container w3-section" >
        <span @click="toggleFormData()" class="w3-closebtn">&times;</span>
            <h3>Tambah Peserta Ujian</h3>
            <gen-table :url="url+'?belumDitambahkan=ya'" :tableContent="tableContentAdd" tableType="list"></gen-table>
        </div>
        </div>
    </div>
    <gen-table :url="url" :tableContent="tableContent" tableType="hapus"></gen-table>
    </div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import { Bus } from '../../../bus.js';
import axios from 'axios';
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaPesertaUjian',
  components : {
      genTable, admin
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/mahasiswa',
          tableContent : {
                header :  ['Nama Peserta','Status'],
                content : ['id','nm_mahasiswa','status']
            },
          tableContentAdd : {
                header :  ['Nama Mahasiswa'],
                content : ['nm_mahasiswa']
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
            var data = {id_peserta : id,id_ujian:this.$route.params.idUjian}
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
