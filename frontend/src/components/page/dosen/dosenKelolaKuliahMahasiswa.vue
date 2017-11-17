<template>
    <dosen>
    <div class="w3-container">
        <h2>Daftar Mahasiswa Kuliah</h2>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain" :aksi.Boolean="false" :formButton.Boolean="false"></gen-table>
    </div>
</dosen>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import { Bus } from '../../../bus.js';
import axios from 'axios';
import dosen from './halamanDosen.vue'

export default {
  name: 'dosenKelolaKuliahMahasiswa',
  components : {
      genTable, dosen
  },
  data () {
      return {
          url : 'kuliah/'+this.$route.params.idKuliah+'/mahasiswa',
          tableContent : {
                header :  ['NOBP','Nama Mahasiswa'],
                content : ['id_kmhs','nobp','nm_mahasiswa']
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
            var data = {id_mahasiswa : id,id_kuliah:this.$route.params.idKuliah}
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
