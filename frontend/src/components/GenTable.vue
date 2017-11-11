<template>
<div class="w3-container">
  <div class="w3-responsive">
        <template v-if="spinStatus == false">
              <template v-if="dataTable.length > 0">
              <div class="w3-margin">
              <div class="w3-col l4 s12">
                <button type="button" @click="getData(pageRows,null)" class="w3-button w3-deep-orange w3-left w3-clear"><i class="fa fa-refresh" style="font-size:17px"></i> Refresh</button>
                <button type="button" v-for="p in pageRowsList" @click="getData(p,0)" class="w3-button w3-border w3-border-black w3-blue w3-hover-indigo w3-right w3-clear">{{p}}</button>
              </div>
            </div>
              <table :class="tableCenter">
                <tr class="w3-teal">
                  <th>#</th>
                  <th v-for="th in tableContent.header" v-if="th != pk">{{th}}</th>
                  <th v-if="aksi">Aksi</th>
                </tr>
                <tr class="w3-white" v-for="(tr,index,key) in dataTable">
                  <td>{{index+1}}</td>
                  <td v-for="td in tableContent.content" v-if="td != pk">{{tr[td]}}</td>
                  <td v-if="aksi">
                    <template v-if="tableType == 'edit_hapus'">
                    <button @click="getDataDetail(tr[pk])" class="w3-btn w3-small w3-teal"><i class="fa fa-edit w3-small"></i> <b>Edit</b>
                    </button>
                    <button @click="deleteData(tr[pk])" class="w3-btn w3-small w3-red"><i class="fa fa-close w3-small"></i> <b>Hapus</b>
                    </button>
                    </template>
                    <template v-else-if="tableType == 'edit'">
                    <button @click="deleteData(tr[pk])" class="w3-btn w3-small w3-red"><i class="fa fa-close w3-small"></i> <b>Hapus</b>
                    </button>
                    </template>
                    <template v-else-if="tableType == 'hapus'">
                    <button @click="deleteData(tr[pk])" class="w3-btn w3-small w3-red"><i class="fa fa-close w3-small"></i> <b>Hapus</b>
                    </button>
                    </template>
                    <template v-else-if="tableType == 'tambahkan'">
                    <button @click="addDataList(tr[pk])" class="w3-btn w3-small w3-teal"><i class="fa fa-edit w3-small"></i> <b>Tambahkan</b>
                    </button>
                    </template>
                    <template v-else>
                    
                    </template>
                    <slot name="customAction" :pkData="tr"></slot>
                  </td>
                </tr>
                </table>
                <button type="button" v-for="(pn,index,key) in pageNumberList" @click="getData(pageRows,pn)" class="w3-button w3-border w3-border-black w3-blue w3-hover-indigo">{{index+1}}</button>
                <br/>
              </template>
              <template v-else>
                  Data kosong<br/>
                  <button type="button" @click="getData(pageRows,null)" class="w3-button w3-deep-orange w3-left w3-clear"><i class="fa fa-refresh" style="font-size:17px"></i> Refresh</button>
              </template>
          </template>
          <template v-else>
          <i class="fa fa-spinner w3-spin w3-center" style="font-size:30px;"></i>
          </template>
  </div>
</div>
</template>

<script>
import axios from 'axios';
import { Bus } from '../bus.js';

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
				return [10,25,50]
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
        }
	},
  data () {
    return {
      dataTable : [],
      totalRows : 0,
      pageRows : 10,
      pageNumber : null,
      spinStatus : true,
      showPilihan : false
    }
  },
  created () {
        Bus.$on('newData',()=>{
            this.getData(this.pageRows,this.pageNumber)
            })
        Bus.$emit('newData')
  },
  computed : {
        tableCenter : function () {
            if(this.spinStatus == true || this.dataTable.length < 1) return "w3-table-all w3-centered"
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
		}
	},
  methods : {
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
			axios.get(this.baseUrl+this.url+'?limit='+limit+'&offset='+offset+this.urlQuery)
			.then(res=>{
                if(res.data.status == true){
                    this.totalRows = res.data.row
                    this.dataTable = res.data.data
                }else{
                    this.dataTable = []
                }
                this.spinStatus = false
			})
			.catch(err=>{
				console.log(err)
                this.spinStatus = false
			})
		},
		deleteData (id) {
			axios({
				method : 'DELETE',
				url :this.baseUrl+this.url+'/'+id
				})
			.then(res=>{
				this.getData(this.pageRows,this.pageNumber)
			})
			.catch(err=>{
				console.log(err)
			})
		},
        getDataDetail (x) {
            Bus.$emit('getDataDetail',x)
        },
        addDataList (x) {
            Bus.$emit('addDataList',x)
        }
	},
    destroyed () {

    }
}
</script>

<style scoped>

</style>
