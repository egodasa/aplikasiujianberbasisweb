<template>
<div class="w3-container">
    <h2>Informasi Ujian</h2>
    <div id="infoUjian" :style="!loading ? 'display:block;':'display:none;height:300px;'">
        <template v-if="infoUjian == null">
            Tidak Dapat Menampilkan Info Ujian<br/>
            <button type="button" class="w3-button w3-blue" @click="detailUjian()">Refresh</button>
        </template>
        <template v-else>
            <div class="w3-row">
                <div class="w3-col l6 s12 xs12">
                <table class="w3-table w3-border w3-bordered">
                        <tr>
                        <td class="w3-white">Mata Kuliah</td>
                        <td class="w3-white">{{infoUjian.nm_matkul}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Kelas</td>
                        <td class="w3-white">
                            {{infoUjian.nm_kelas.toString()}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Hari</td>
                        <td class="w3-white">{{infoUjian.hari}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Jenis Ujian</td>
                        <td class="w3-white">{{infoUjian.nm_jujian}}</td>
                        </tr>
                </table>
                </div>
                <div class="w3-col l6 s12 xs12">
                <table class="w3-table w3-border w3-bordered">
                    <tr>
                    <td class="w3-white">Dosen</td>
                    <td class="w3-white">{{infoUjian.nm_dosen}}</td>
                    </tr>
                    <tr>
                    <td class="w3-white">Tahun Akademik</td>
                    <td class="w3-white">{{infoUjian.tahun_akademik}}</td>
                    </tr>
                    <tr>
                    <td class="w3-white">Waktu</td>
                    <td class="w3-white">{{infoUjian.mulai +' - '+ infoUjian.selesai}}</td>
                    </tr>
                    <tr>
                    <td class="w3-white">Jenis Soal</td>
                    <td class="w3-white">{{infoUjian.nm_jsoal}}</td>
                    </tr>
                </table>
                </div>
            </div>
        </template>
    </div>
    
<div class="w3-section w3-border w3-white w3-mobile">
<div class="w3-bar w3-light-gray">
<button type="button" :class="currentTabs != 'soalUjian' ? 'w3-button w3-bar-item w3-light-gray w3-mobile' : 'w3-button w3-hover-white w3-bar-item w3-white w3-mobile'" @click="changeTabs('soalUjian')"><b>Soal Ujian</b></button>
<button type="button" :class="currentTabs != 'hasilUjian' ? 'w3-button w3-bar-item w3-light-gray w3-mobile' : 'w3-button w3-hover-white w3-bar-item w3-white w3-mobile'" @click="changeTabs('hasilUjian')"><b>Hasil Ujian</b></button>
</div>
<br/>
    <keep-alive>
        <components :is="currentTabs" :infoUjian="infoUjian">
        </components>
    </keep-alive>
</div>
</div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import dosen from './halamanDosen.vue'
import hasilUjian from './hasilUjian.vue'
import soalUjian from './kelolaSoalUjian.vue'
import kelolaPesertaUjian from './kelolaPesertaUjian.vue'
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'

export default {
  name: 'kelolaUjianDetail',
  components : {
      'genTable' : genTable,
      'genForm' : genForm,
      'dosen' : dosen,
      'hasilUjian' : hasilUjian,
      'soalUjian' : soalUjian,
      'pesertaUjian' : kelolaPesertaUjian
  },
  data () {
      return {
          url : 'ujian',
          infoUjian : null,
          tableSummary : {
              title : ['Mata Kuliah','Dosen','Kelas','TA','Hari','Jenis Ujian','Jenis Soal','Mulai','Selesai'],
              content : ['nm_matkul','nm_dosen','nm_kelas','tahun_akademik','hari','nm_jujian','nm_jsoal','mulai','selesai']
          },
          currentTabs : 'soalUjian',
          periksaSoal : false,
          loading : false
        }
    },
  created (){
      this.detailUjian()
  },
  methods : {
      changeTabs (x){
          this.currentTabs = x
      },
      detailUjian () {
          this.$ajx.get('./api/ujian/'+this.$route.params.idUjian)
            .then(res=>{
                this.infoUjian = res.data.data[0]
                
                bus.$emit('getKelas',this.infoUjian.nm_kelas)
                this.infoUjian.hari = formatWaktu(new Date(this.infoUjian.hari), 'DD MMMM YYYY', {locale : lokalisasi})
                this.periksaSoal = this.infoUjian.id_jsoal == 2
                })
            .catch(err=>{
                
                })
      }
  }
}
</script>

<style scoped>

</style>
