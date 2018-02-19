<template>
<div class="w3-responsive">
    <template v-if="spinStatus == false">
                <span class="w3-left">
                <slot name="customButton"></slot>
                <button type="button" @click="toggleFormData()" class="w3-button w3-blue w3-hover-blue-grey w3-small" v-if="formButton"><b><i class="fa fa-plus"></i> Tambah Data</b></button>
                <button type="button" @click="getData(pageRows,null)" class="w3-button w3-blue w3-hover-blue-grey w3-small" v-if="refreshButton"><b><i class="fa fa-refresh"></i> Refresh</b></button>
                <div class="w3-dropdown-click" v-if="exportButton">
                <button class="w3-button w3-blue w3-small" @click="toggleCetakMenu()"><i class="fa fa-save"></i> Cetak</button>
                <div :class="cetakMenu ? 'w3-dropdown-content w3-bar-block w3-border w3-show' : 'w3-dropdown-content w3-bar-block w3-border'">
                <a v-for="x in exportUrl" class="w3-bar-item w3-button" :href="x.url">{{x.name}}</a>
                </div>
                </div>
                </span>
                <span class="w3-right">
                <slot name="customSearch">
                <input type="search" class="w3-button w3-small w3-border w3-white" v-model="cari" placeholder="Pencarian..." @keyup.enter="cariData()"/> 
                <button type="button" class="w3-button w3-red w3-hover-blue-gray w3-small" @click="resetCariData()">Reset</button>
                </slot>
                </span>
                <div class="w3-clear"></div>
            <template v-if="statusCodeDataTable == 200 && dataTable.row != 0">
            <table :class="tableCenter" style="margin-top:5px;">
            <tr class="w3-teal">
                <th>No</th>
                <th v-for="th in tableContent" v-if="th.show">{{th.caption}}</th>
                <th v-if="aksi">Aksi</th>
            </tr>
            <tr class="w3-white w3-hover-light-gray" v-for="(tr,index,key) in dataTable.data">
                <td v-if="rowNumber">{{index+1+numStart}}</td>
                <td v-for="td in tableContent" v-if="td.show" v-html="tr[td.name]"></td>
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
                <td :colspan="columnTotal" class="w3-white w3-center">
                    <span class="w3-right">
                        <a class="w3-button w3-hover-white"><b>Total Data {{dataTable.row}} baris</b></a>
                    </span>
                    <span class="w3-left">
                        <a class="w3-button w3-hover-white"><b>{{'Halaman '+ pagePosition +' dari '+pageNumberList}}</b></a>
                    </span>
                    
                </td>
            </tr>
            </table>
            <div class="w3-row w3-margin-top">
                <div class="w3-col l6 md6 xs12 s12">
                <div class="w3-bar">
                    <button type="button" class="w3-button w3-teal w3-bar-item" @click="getData(pageRows,pagePosition-1)" :disabled="pagePosition == 1"><b>Sebelumnya</b></button>
                    <input v-model="pageNumberInput" style="width:20%;height:38px;margin: 0px 5px;" min=1 :max.Number="pageNumberList.length" @blur="getData(pageRows,pageNumberInput)" @keyup.enter="getData(pageRows,pageNumberInput)" class="w3-input w3-border w3-bar-item" type="number" />
                    <button type="button" class="w3-button w3-teal w3-bar-item" @click="getData(pageRows,pagePosition+1)" :disabled="pagePosition == pageNumberList"><b>Selanjutnya</b></button>
                </div>
                </div>
                <div class="w3-col l6 md6 xs12 s12">
                    <div class="w3-bar">
                        <input v-model="pageRowsInput" style="width:20%;height:38px;" min=1 @keyup.enter="getData(pageRowsInput,1)" class="w3-input w3-border w3-bar-item w3-right" @blur="getData(pageRowsInput,1)" type="number" />
                        <span class="w3-bar-item w3-right">Banyak data perhalaman</span>
                    </div>
                </div>
            </div>
            <br/>
            </template>
            <template v-else>
                <div class="w3-display-container" style="height:300px;">
                <div class="w3-display-middle">
                    <div class="w3-text-blue-gray" style="font-size:40px;text-align:center;">{{statusDataTable}}</div><br/>
                    <!--
                    <div class="w3-center">
                    <button type="button" @click="toggleFormData()" class="w3-button w3-center w3-blue-grey" :disabled="statusCodeDataTable >= 500" v-if="formButton"><i class="fa fa-plus"></i> Tambah Data</button>
                <button type="button" @click="getData(pageRows,null)" class="w3-button w3-center w3-blue-grey"><i class="fa fa-refresh"></i> Refresh</button>
                    </div>-->
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
                        <img src="./images/loading.gif" class="w3-image" width="200" />
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
        type : Array,
        required : true,
        default : function(){
                return [{}]
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
    no : 0,
    dataTable : [],
    totalRows : 0,
    pageRows : 10,
    pageRowsInput : 10,
    pagePosition : 1,
    pageNumberInput : 1,
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
    bus.$on('newData',this.getData)
    this.getData(this.pageRows,this.pagePosition)
},
computed : {
    tableCenter : function () {
        if(this.spinStatus == true || this.dataTable.data.length < 1) return "w3-table-all w3-centered w3-card"
        else return "w3-table-all w3-card"
    },
    pageNumberList : function () {
        var pn
        var pnl = []
        pn = Math.ceil(this.totalRows/this.pageRows)
        return pn
    },
    columnTotal : function(){
        var aksi,pk,numb
        this.aksi ? aksi=1 : aksi = 0
        this.showPk ? pk=1 : pk = 0
        this.rowNumber ? numb=1 : numb = 0
        return this.tableContent.length+numb+aksi+pk
    },
    numStart : function(){
        return (this.pagePosition-1)*this.pageRows
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
    getData (limit,offset) {
        if(offset < 1 || offset > this.pageNumberList) {
            offset = 1
            this.pageNumberInput = 1
        }
        this.spinStatus = true
        this.pageNumberInput = offset
        this.pageRows = limit
        this.pagePosition = offset
        offset = (offset-1)*this.pageRows
        var url
        if(this.pencarian == true){
            if(this.cari == undefined || this.cari == null || this.cari == ""){
                url = this.baseUrl+this.url+'?limit='+limit+'&offset='+offset+this.urlQuery
            }else url = this.baseUrl+this.url+'/cari/'+this.cari+'?limit='+limit+'&offset='+offset+this.urlQuery
        }else url = this.baseUrl+this.url+'?limit='+limit+'&offset='+offset+this.urlQuery
        this.$ajx.get(url)
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
        if(window.confirm("Apakah yakin ingin menghapus data ini?")){
            this.$ajx({
            method : 'DELETE',
            url :this.baseUrl+this.url+'/'+id
            })
            .then(res=>{
                this.getData(this.pageRows,this.pagePosition)
            })
            .catch(err=>{
                bus.$emit('showAlert','Peringatan!','Gagal menghapus data!','warning')
            })
        }
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
        this.getData(10,0,1)
    },
    resetCariData () {
        this.pencarian = false
        this.getData(10,0,1)
    }
},
destroyed () {
    bus.$off('newData',this.getData)
}
}
</script>

<style scoped>
</style>
