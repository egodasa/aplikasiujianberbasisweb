<template>
<div class="w3-container">
    <gen-form :pk="id_sujian" url="custom" :input="listForm" contentType="lain">
        <form id="addData" @submit.prevent="submitData()" name="addData">
            <h3>Tambah Soal</h3>
            <input class="w3-radio" type="hidden" name="id_jsoal" v-model="dataForm.id_jsoal" />
            <label>Isi Soal</label>
            <div class="w3-mobile">
            <wysiwyg v-model="dataForm.isi_soal" />
            </div>
            <span class="w3-text-red" v-if="errors.has('isi_soal')">{{ errors.first('isi_soal') }}</span><br/>
            <template v-if="dataForm.id_jsoal == 1">
            <div class="w3-row">
                <div class="w3-col l1">
                    <input v-for="(x,index,key) in dataForm.pilihanGanda" class="w3-input w3-border" type="text" v-model="dataForm.pilihanGanda[index].huruf" placeholder="Huruf" /><label class="w3-label w3-text-red"></label>
                </div>
                <div class="w3-col l11">
                    <input v-for="(x,index,key) in dataForm.pilihanGanda" class="w3-input w3-border" type="text" v-model="dataForm.pilihanGanda[index].isi_pilihan" placeholder="Isi Pilihan Ganda" /><label class="w3-label w3-text-red"></label><br/>
                </div>
            </div>
            <button class="w3-btn w3-tiny w3-teal" type="button" @click="addPG()">+</button>
            <button class="w3-btn w3-tiny w3-red" type="button" @click="deletePG()">-</button>
            <br/> <label>Jawaban</label>
                <div v-for="(x,index,key) in dataForm.pilihanGanda">
                    <template v-if="index  == 1">
                    <input class="w3-radio" type="radio" name="Huruf" v-validate data-vv-rules="required" data-vv-as="Jawaban" v-model="dataForm.jawaban" :value="x.huruf" /> <label class="w3-label">{{x.huruf}}</label>
                    </template>
                    <template v-else>
                    <input class="w3-radio" type="radio" name="Huruf" v-model="dataForm.jawaban" :value="x.huruf" /> <label class="w3-label">{{x.huruf}}</label>
                    </template>
                </div>
            </template>
            <template v-else>
            <label>Bobot Nilai</label>
            <input class="w3-input w3-border" v-validate data-vv-rules="required" data-vv-as="Bobot Soal" type="number" name="bobot" v-model="dataForm.bobot" placeholder="Bobot Nilai Soal" />
            <span class="w3-text-red" v-if="errors.has('bobot')">{{ errors.first('bobot') }}</span>
            </template>
            <span class="w3-text-red" v-if="errors.has('jawaban')">{{ errors.first('jawaban') }}</span><br/>
            <button :disabled="errors.any()" type="submit" class="w3-button w3-teal w3-section">Simpan</button>
            <button type="button" class="w3-button w3-red w3-section" @click="resetForm()">Reset</button>
            <button type="button" class="w3-button w3-blue w3-section" @click="formBatal()">Batal</button>
        </form>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" ref="genTable" :tableContent="tableContent" tableType="hapus">
    <template slot="customAction" slot-scope="ca">
        <span class="hint--top" aria-label="Edit"><button class="w3-button w3-hover-white w3-white" @click="getDataDetail(ca.pkData.id_soal)"><i class="fa fa-edit"></i> 
        </button></span>
    </template>
    </gen-table>
    </div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'

export default {
  name: 'kelolaSoalUjian',
  components : {
      genTable, genForm
  },
  data () {
      return {
          tableContent : {
              header : ['Isi Soal','Bobot'],
              content : ['id_soal','isi_soal','bobot']
          },
          url : 'ujian/'+this.$route.params.idUjian+'/soal',
          showForm : false,
          dataForm : {
              isi_soal : "-",
              jawaban : null,
              pilihanGanda : [
                  {huruf:'A',isi_pilihan:null},
                  {huruf:'B',isi_pilihan:null},
                  {huruf:'C',isi_pilihan:null},
                  {huruf:'D',isi_pilihan:null},
                  {huruf:'E',isi_pilihan:null}
                ],
            id_jsoal : null,
            bobot : 1
          },
          pilihanGandaDef : [
          {huruf:'A',isi_pilihan:null},
          {huruf:'B',isi_pilihan:null},
          {huruf:'C',isi_pilihan:null},
          {huruf:'D',isi_pilihan:null},
          {huruf:'E',isi_pilihan:null}
          ],
          detailUjian : {}
        }
  },
  created () {
      this.getDetailUjian()
  },
  methods : {
      formBatal () {
          this.resetForm()
          this.$refs.genTable.toggleFormData()
      },
      getDetailUjian () {
          this.$ajx.get('/api/ujian/'+this.$route.params.idUjian)
          .then(res=>{
              this.detailUjian = res.data.data[0]
              this.dataForm.id_jsoal = this.detailUjian.id_jsoal
              })
          .catch(err=>{
              console.log(err)
              })
      },
      toggleFormData () {
           this.showForm = !this.showForm
        },
        addPG () {
        if(this.dataForm.pilihanGanda.length != this.pilihanGandaDef.length){
            this.dataForm.pilihanGanda.push({huruf:this.pilihanGandaDef[this.dataForm.pilihanGanda.length].huruf,isi_pilihan:null})
        }else{
            this.dataForm.pilihanGanda.push({huruf:null,isi_pilihan:null})
        }
      },
      deletePG () {
          if(this.dataForm.pilihanGanda.length != 2){
            this.dataForm.pilihanGanda.pop()
          }
      },
      resetForm () {
          this.dataForm.isi_soal = "-"
          this.dataForm.jawaban = null
          this.dataForm.id_soal = undefined
          this.dataForm.pilihanGanda = [
          {huruf:'A',isi_pilihan:null},
          {huruf:'B',isi_pilihan:null},
          {huruf:'C',isi_pilihan:null},
          {huruf:'D',isi_pilihan:null},
          {huruf:'E',isi_pilihan:null}
          ]
          this.id_jsoal = this.detailUjian.id_jsoal
          this.dataForm.bobot = null
      },
      submitData () {
          if(this.dataForm.id_jsoal == 2) this.dataForm.pilihanGanda = undefined
          if(this.dataForm.id_soal == undefined || this.dataForm.id_soal == null){
              var method = 'POST'
              var url = "/api/ujian/"+this.$route.params.idUjian+'/soal'
          }else {
              var method = 'PUT'
              var url = '/api/soal/'+this.dataForm.id_soal
          }
          console.log(this.$refs.vueEditor.content)
          this.dataForm.isi_soal = this.$refs.vueEditor.content
          this.$ajx({
            method : method,
            data : this.dataForm,
            url :url,
            })
          .then(res=>{
            if(res.data.status == false) console.log(res.data)
            else {
                this.$refs.genTable.toggleFormData()
                this.$refs.genTable.getData(this.$refs.genTable.pageRows,this.$refs.genTable.pagePosition)
                this.resetForm()
            }
        })
        .catch(err=>{
            console.log(err)
        })
		},
      getDataDetail (x) {
          this.$ajx({
            method : 'GET',
            url :'/api/soal/'+x,
            })
          .then(res=>{
            if(res.data.status == false) console.log(res.data)
            else {
                let hasil = res.data.data[0]
                this.dataForm = hasil
                this.$refs.genTable.toggleFormData()
            }
        })
        .catch(err=>{
            var kode = err.response.status
            if(kode > 300){
                bus.$emit('showAlert','Peringatan!','Tidak dapat mengambil data. Silahkan ulangi kembali.','warning')
            }else{
                bus.$emit('showAlert','Peringatan!','Terjadi kesalahan pada server!.','warning')
            }
        })
		}
  },
  destroyed () {
      //bus.$off('getDataDetail')
  }
}
</script>

<style src="../../../../node_modules/vue-wysiwyg/dist/vueWysiwyg.css">

</style>
