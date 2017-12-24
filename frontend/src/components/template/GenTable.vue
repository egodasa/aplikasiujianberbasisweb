<template>
  <div class="w3-responsive">
        <template v-if="spinStatus == false">
              <template v-if="statusCodeDataTable == 200 && dataTable.row != 0">
              <span class="w3-left">
              <button type="button" @click="toggleFormData()" class="w3-button w3-blue w3-hover-blue-grey w3-small" v-if="formButton"><i class="fa fa-plus"></i> Tambah Data</button>
              <button type="button" @click="getData(pageRows,null)" class="w3-button w3-blue w3-hover-blue-grey w3-small" v-if="refreshButton"><i class="fa fa-refresh"></i> Refresh</button>
              <div class="w3-dropdown-click" v-if="exportButton">
              <button class="w3-button w3-blue w3-small" @click="toggleCetakMenu()"><i class="fa fa-save"></i> Cetak</button>
              <div :class="cetakMenu ? 'w3-dropdown-content w3-bar-block w3-border w3-show' : 'w3-dropdown-content w3-bar-block w3-border'">
                <a v-for="x in exportUrl" class="w3-bar-item w3-button" :href="x.url">{{x.name}}</a>
              </div>
              </div>
              </span>
              <span class="w3-right">
              <input type="search" class="w3-class w3-bordered w3-big" v-model="cari" /> 
              <button type="button" class="w3-button w3-green w3-hover-blue-gray w3-small" @click="cariData()"><i class="fa fa-search"></i></button>
              <button type="button" class="w3-button w3-red w3-hover-blue-gray w3-small" @click="resetCariData()"><i class="fa fa-close  "></i></button>
              </span>
              <table :class="tableCenter">
                <tr class="w3-teal">
                  <th>#</th>
                  <th v-for="th in tableContent.header" v-if="th != pk">{{th}}</th>
                  <th v-if="aksi">Aksi</th>
                </tr>
                <tr class="w3-white w3-hover-light-gray" v-for="(tr,index,key) in dataTable.data">
                  <td v-if="rowNumber">{{index+1}}</td>
                  <template v-if="showPk == true">
                    <td v-for="td in tableContent.content">{{tr[td]}}</td>
                  </template>
                  <template v-else>
                    <td v-html="tr[td]" v-for="td in tableContent.content" v-if="td != pk"></td>
                  </template>
                  <td v-if="aksi">
                    <template v-if="tableType == 'edit_hapus'">
                    <span class="hint--top" aria-label="Edit"><button class="w3-button w3-hover-white w3-white" @click="getDataDetail(tr[pk])"><i class="fa fa-edit"></i> 
                    </button></span>
                    <span class="hint--top" aria-label="Hapus"><button class="w3-button w3-hover-white w3-white" @click="deleteData(tr[pk])"><i class="fa fa-close"></i> 
                    </button></span>
                    </template>
                    <template v-else-if="tableType == 'edit'">
                    <span class="hint--top" aria-label="Edit"><button class="w3-button w3-hover-white w3-white" @click="getDataDetail(tr[pk])"><i class="fa fa-close"></i> 
                    </button></span>
                    </template>
                    <template v-else-if="tableType == 'hapus'">
                    <span class="hint--top" aria-label="Hapus"><button class="w3-button w3-hover-white w3-white" @click="deleteData(tr[pk])"><i class="fa fa-close"></i> 
                    </button></span>
                    </template>
                    <template v-else-if="tableType == 'tambahkan'">
                    <span class="hint--top" aria-label="Tambahkan ..."><button class="w3-button w3-hover-white w3-white" @click="addDataList(tr[pk])"><i class="fa fa-edit"></i> <b>Tambahkan</b>
                    </button></span>
                    </template>
                    <template v-else>
                    </template>
                    <slot name="customAction" :pkData="tr"></slot>
                  </td>
                </tr>
                <tr>
                    <td :colspan="columnTotal" class="w3-center w3-teal"><b>Total Data : {{dataTable.row}} baris</b></td>
                </tr>
                </table>
                <div class="w3-section">
                    Halaman <br/>
                    <button type="button" style="margin-right:3px;"  v-for="(pn,index,key) in pageNumberList" @click="getData(pageRows,pn)" :class="pageNumber != pn ? 'w3-button w3-border w3-border-light-grey w3-teal w3-hover-white' : 'w3-button w3-border w3-border-light-grey w3-pale-green'">{{index+1}}</button>
                </div>
                <div class="w3-section">
                    Banyak data perhalaman <br/>
                    <button type="button" style="margin-right:3px;" v-for="p in pageRowsList" @click="getData(p,0)" :class="p == pageRows ? 'w3-button w3-border w3-border-light-grey w3-pale-green w3-hover-white' : 'w3-button w3-border w3-border-light-grey w3-teal w3-hover-white'">{{p}}</button>
                </div>
                <br/>
              </template>
              <template v-else>
                  <div class="w3-display-container" style="height:300px;">
                  <div class="w3-display-middle">
                      <div class="w3-text-blue-gray" style="font-size:40px;text-align:center;">{{statusDataTable}}</div><br/>
                      <div class="w3-center">
                      <button type="button" @click="toggleFormData()" class="w3-button w3-center w3-blue-grey" :disabled="statusCodeDataTable >= 500" v-if="formButton"><i class="fa fa-plus"></i> Tambah Data</button>
                  <button type="button" @click="getData(pageRows,null)" class="w3-button w3-center w3-blue-grey"><i class="fa fa-refresh"></i> Refresh</button>
                      </div>
                    </div>
                  </div>
                  <br/>
                  
              </template>
          </template>
          <template v-else>
              <div class="w3-display-container" style="height:300px;">
                  <div class="w3-display-middle w3-center">
                        <h4>Memuat Data ...</h4>
                        <div class="sk-three-bounce">
                            <img src="/images/loading.gif" class="w3-image" width="200" />
                          </div>
                    </div>
                  </div>
          </template>
  </div>
</template>

<script>
export default {
  name: 'genTable',
  props : {
		aksi : {
			type : Boolean,
			required : false,
			default : true
			},
		pk : {
			type : String,
			required : false,
			default : "id"
			},
		pageRowsList : {
			type : Array,
			required : false,
			default : function(){
				return [10,25,50,100]
			}
		},
        url : String,
        urlQuery : {
            type : String,
            required : false,
            default : ""
        },
        baseUrl : {
            type : String,
            required : false,
            default : "/api/"
        },
        tableType : {
            type : String,
            required : false,
            default : 'edit_hapus'
        },
        tableContent : {
            type : Object,
            required : true,
            default : function(){
                    return {
                    header : [],
                    content : []
                }
            }
        },
        formButton : {
            type : Boolean,
            required : false,
            default : true
        },
        refreshButton : {
            type : Boolean,
            required : false,
            default : true
        },
        exportButton : {
            type : Boolean,
            required : false,
            default : false
        },
        exportUrl : {
            type : Array,
            required : false,
            default : function(){
                return [
                {name:'CSV',url:'api/cetak/csv'},
                {name:'Excel',url:'api/cetak/excel'}
                ]
            }
        },
        showPk : {
            type : Boolean,
            required : false,
            default : false
        },
        rowNumber : {
            type : Boolean,
            required : false,
            default : true
        }
	},
  data () {
    return {
      dataTable : [],
      totalRows : 0,
      pageRows : 10,
      pageNumber : 0,
      spinStatus : true,
      showPilihan : false,
      pencarian : false,
      cari : null,
      cetakMenu : false,
      statusDataTable : null,
      statusCodeDataTable : null
    }
  },
  created () {
        bus.$on('newData',()=>{
            this.getData(this.pageRows,this.pageNumber)
            })
        bus.$emit('newData')
  },
  computed : {
        tableCenter : function () {
            if(this.spinStatus == true || this.dataTable.data.length < 1) return "w3-table-all w3-centered"
            else return "w3-table-all"
        },
		pageNumberList : function () {
			var pn
			var pnl = []
			pn = Math.ceil(this.totalRows/this.pageRows)
			for(var x=0;x<pn;x++){
				pnl[x] = x*this.pageRows
			}
			return pnl
		},
        columnTotal : function(){
            var aksi,pk,numb
            this.aksi ? aksi=1 : aksi = 0
            this.showPk ? pk=1 : pk = 0
            this.rowNumber ? numb=1 : numb = 0
            return this.tableContent.header.length+numb+aksi+pk
        }
	},
  methods : {
        toggleCetakMenu () {
            this.cetakMenu = !this.cetakMenu
        },
        toggleAksi () {
            this.showPilihan = !this.showPilihan
        },
		miliToString (mili) {
			  var jam,menit
			  jam = Math.floor(mili/3600000)
			  menit = mod(mili,60000)
			  return jam + ' Jam ' + menit + ' Menit'
			},
		stringToMili : function (jam,menit) {
			  var mili
			  mili = (jam*3600000)+(menit*60000)
			  return mili
			},
		getData (limit = null,offset = null) {
            this.spinStatus = true
			this.pageRows = limit
			this.pageNumber = offset
            var url
            if(this.pencarian == true){
                url = this.baseUrl+this.url+'/cari/'+this.cari+'?limit='+limit+'&offset='+offset+this.urlQuery
            }else url = this.baseUrl+this.url+'?limit='+limit+'&offset='+offset+this.urlQuery
			ajx.get(url)
			.then(res=>{
                    this.statusCodeDataTable = res.status
                    if(this.statusCodeDataTable == 204 || res.data.row == 0){
                        if(this.pencarian == false){
                            this.statusDataTable = "Data Kosong"
                        }else{
                            this.statusDataTable = "Tidak Ditemukan Hasil Pencarian"
                        }
                    }
                    this.totalRows = res.data.row
                    this.dataTable = res.data
                    this.spinStatus = false
			})
			.catch(err=>{
                if(err.response.status >= 299){
                    this.statusCodeDataTable = err.response.status
                    this.statusDataTable = "Terjadi Kesalahan Pada Server!"
                    this.dataTable = []
                    this.spinStatus = false
                }
				
			})
		},
		deleteData (id) {
			ajx({
				method : 'DELETE',
				url :this.baseUrl+this.url+'/'+id
				})
			.then(res=>{
				this.getData(this.pageRows,this.pageNumber)
			})
			.catch(err=>{
				bus.$emit('showAlert','Peringatan!','Gagal menghapus data!','warning')
			})
		},
        getDataDetail (x) {
            bus.$emit('getDataDetail',x)
        },
        addDataList (x) {
            bus.$emit('addDataList',x)
        },
        toggleFormData () {
            bus.$emit('toggleFormData')
        },
        cariData () {
            this.pencarian = true
            this.getData(10,0)
        },
        resetCariData () {
            this.pencarian = false
            this.getData(10,0)
        }
	},
    destroyed () {

    }
}
</script>

<style scoped>
.sk-three-bounce {
  margin: 40px auto;
  width: 80px;
  text-align: center; }
  .sk-three-bounce .sk-child {
    width: 20px;
    height: 20px;
    background-color: #333;
    border-radius: 100%;
    display: inline-block;
    -webkit-animation: sk-three-bounce 1.4s ease-in-out 0s infinite both;
            animation: sk-three-bounce 1.4s ease-in-out 0s infinite both; }
  .sk-three-bounce .sk-bounce1 {
    -webkit-animation-delay: -0.32s;
            animation-delay: -0.32s; }
  .sk-three-bounce .sk-bounce2 {
    -webkit-animation-delay: -0.16s;
            animation-delay: -0.16s; }

@-webkit-keyframes sk-three-bounce {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0); }
  40% {
    -webkit-transform: scale(1);
            transform: scale(1); } }

@keyframes sk-three-bounce {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0); }
  40% {
    -webkit-transform: scale(1);
            transform: scale(1); } }
</style>
