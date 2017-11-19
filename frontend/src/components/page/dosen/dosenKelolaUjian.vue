<template>
<dosen>
<div class="w3-container">
    <h2>Kelola Ujian</h2>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain" :formButton.Boolean="false">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Daftar Soal">
                <router-link :to="{name:'dosenKelolaSoalUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-list-alt "></i></router-link>
            </span>
            <span class="hint--top" aria-label="Periksa Ujian">
                <router-link :to="{name:'dosenJawabanUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white" v-if="ca.pkData.id_jsoal == 2 ? true : false"><i class="fa fa-check-square-o "></i></router-link>
            </span>
            <span class="hint--top" aria-label="Hasil Ujian">
                <router-link :to="{name:'dosenHasilUjian',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white" ><i class="fa fa-list-ol "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>
</dosen>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import axios from 'axios'
import dosen from './halamanDosen.vue'

export default {
  name: 'dosenKelolaUjian',
  components : {
      genTable, dosen
  },
  data () {
      return {
          url : 'ujian?nidn='+this.$session.get('user').username+'&',
            tableContent : {
                header :  ['Matkul','Jenis','Kelas','Tipe Ujian'],
                content : ['id_ujian','nm_matkul','nm_jujian','nm_kelas','jsoal']
            }
        }
  },
  beforeCreate () {
      if(!this.$session.has('user')) this.$router.push({path: '/login'})
  }
}
</script>

<style scoped>

</style>
