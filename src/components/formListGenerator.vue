<template>
<div id="genForm">
    <button type="button" @click="toggleFormList()" class="w3-button w3-blue">Tambah Data</button>
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content w3-animate-top">
          <gen-table tableType="list" :url="url" :header="tableHeader"></gen-table>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import { Bus } from '../bus.js';
import genTable from './GenTable.vue'

export default {
    name : 'genFormList',
    components : {
        genTable
    },
	props : {
		url : String,
        pk : {
            type : String,
            required : false,
            default : 'id'
        }
	},
	data () {
		return {
            showForm : false,
            idData : null,
            output : {}
		}
	},
    created () {
        Bus.$on('toggleFormList',()=>{
            this.toggleFormData()
            })
        Bus.$on('addDataList', x =>{
            this.submitData(x)
        })
        this.showForm = false
    },
	methods : {
        toggleFormData (){
            //this.idData = x
            console.log('Sebelum '+ this.showForm)
            this.showForm = !this.showForm
            console.log('Sesudah '+ this.showForm)
            //console.log(this.showForm)
            //if(x != 0) this.getDataDetail(x)
        },
		submitData (x){
            var output_new = {}
            output_new[pk] = x
			axios({
				method : 'POST',
				data : output_new,
				url :'/api/'+this.url+url,
				})
			.then(res=>{
				if(res.data.status == false) console.log(res.data)
				else {
                    Bus.$emit('newData')
                    this.toggleFormData()
					console.log('berhasil ' + res)
				}
			})
			.catch(err=>{
				console.log(err)
			})
		}
	}
}
</script>

<style scoped>

</style>
