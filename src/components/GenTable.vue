<template>
<div class="w3-container">
  <div class="w3-responsive">
    <div class="w3-margin">
      <div class="w3-col l4 s12">
        <button type="button" @click="getData(pageRows,null)" class="w3-button w3-deep-orange w3-left w3-clear"><i class="fa fa-refresh" style="font-size:17px"></i> Refresh</button>
        <button type="button" v-for="p in pageRowsList" @click="getData(p,0)" class="w3-button w3-border w3-border-black w3-blue w3-hover-indigo w3-right w3-clear">{{p}}</button>
      </div>
    </div>
    <table class="w3-table-all">
      <tr class="w3-teal">
        <th>#</th>
        <th v-for="th in header" v-if="th != 'id'">{{th}}</th>
        <th v-if="aksi">Aksi</th>
      </tr>
      <template v-if="dataTable.length > 0">
        <tr class="w3-white" v-for="(tr,index,key) in dataTable">
          <td>{{index+1}}</td>
          <td v-for="td in Object.keys(dataTable[0])" v-if="td != 'id'">{{tr[td]}}</td>
          <td v-if="aksi">
            <button type="button" @click="getDataDetail(tr[pk])" class="w3-btn w3-small w3-teal"><i class="fa fa-edit w3-small"></i> <b>Edit</b>
            </button>
            <button type="button" @click="deleteData(tr[pk])" class="w3-btn w3-small w3-red"><i class="fa fa-close w3-small"></i> <b>Hapus</b>
            </button>
          </td>
        </tr>
      </template>
      <template v-else>
        <tr>
          <td :colspan="header.length">Data kosong</td>
        </tr>
      </template>
    </table>
    <button type="button" v-for="(pn,index,key) in pageNumberList" @click="getData(pageRows,pn)" class="w3-button w3-border w3-border-black w3-blue w3-hover-indigo">{{index+1}}</button>
    <br/>
  </div>
</div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'genTable',
  props : {
		header : Array,
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
        url : String
	},
  data () {
    return {
      dataTable : [],
      totalRows : 0,
      pageRows : 10,
      pageNumber : null
    }
  },
  created () {
		self = this
        self.getData(self.pageRows,self.pageNumber)
        /*
        bus.$on('newData',function () {
            self.getData(self.pageRows,self.pageNumber)
            })
        bus.$emit('newData')*/
  },
  computed : {
		pageNumberList : function () {
			var pn
			var pnl = []
			pn = Math.ceil(self.totalRows/self.pageRows)
			for(var x=0;x<pn;x++){
				pnl[x] = x*self.pageRows
			}
			return pnl
		}
	},
  methods : {
		miliToString : function (mili) {
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
		getData : function (limit = null,offset = null) {
			self.pageRows = limit
			self.pageNumber = offset
			axios.get('http://localhost:3000/api/'+self.url+'?limit='+limit+'&offset='+offset)
			.then(function (res) {
				self.totalRows = res.data.row
				self.dataTable = res.data.data
			})
			.catch(function (err) {
				console.log(err)
			})
		},
		deleteData : function (id) {
			axios({
				method : 'DELETE',
				url :'http://localhost:3000/api/'+this.url+'/'+id
				})
			.then(function (res) {
				self.getData(self.pageRows,self.pageNumber)
			})
			.catch(function (err) {
				console.log(err)
			})
		},/*
        getDataDetail : function (x) {
            //bus.$emit('getDataDetail',x)
        }*/
	}
}
</script>

<style scoped>

</style>
