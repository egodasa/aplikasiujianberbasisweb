<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Ujian</h2>
    </div>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'

export default {
  name: 'kelolaUjian',
  components : {
      genTable
  },
  data () {
      return {
          url : 'ujian',
            listForm : [
                {
					caption: "Nama Ujian",
					name:"nm_ujian",
					jenis:"textField",
					tipe:"text",
					value:null
					},
				{
					caption: "Jam",
					name:"jam",
					jenis:"textField",
					tipe:"number",
					value:null,
					min:0,
					max:60
					},
				{
					caption: "Menit",
					name:"menit",
					jenis:"textField",
					tipe:"number",
					value:null ,
					min:0,
					max:60
					}
			],
            tableHeader : ['Nama Ujian','Jam','Menit','Banyak Peserta','Banyak Soal']
        }
  }
}
</script>

<style scoped>

</style>
