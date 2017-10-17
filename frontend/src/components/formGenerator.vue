<template>
<div id="genForm">
    <button type="button" @click="toggleFormData()" class="w3-button w3-blue">Tambah Data</button>
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content w3-animate-top">
        <form class="w3-card-8 w3-container w3-section" v-if="showForm" id="addData" @submit.prevent="submitData()" name="addData" method="POST">
            <h3>Tambah Data</h3>
            <span v-for="x in input">
                <template v-if="x.jenis == 'textField'">
                    <template v-if="x.tipe == 'number'">
                        <input class="w3-input w3-border"  :placeholder="x.caption" type="number" :name="x.name" :min="x.min" :max="x.max" v-model.number="output[x.name]" />
                    </template>
                    <template v-else-if="x.tipe == 'email'">
                        <input class="w3-input w3-border"  :placeholder="x.caption" type="email" :name="x.name" v-model="output[x.name]" />
                    </template>
                    <template v-else>
                        <input class="w3-input w3-border"  :placeholder="x.caption" type="text" :name="x.name" v-model="output[x.name]" />
                    </template>
                    <br/>
                </template>
                <template v-else-if="x.jenis == 'radioButton'">
                <label for="x.name" v-for="(y,index,key) in x.option">
                    <span v-if="index < 1">{{x.caption}}<br/></span>
                    <input type="radio" :name="x.name" v-bind="output['x.name']" />{{y}}<br/>
                </label>
                </template>
                <template v-else="x.jenis == 'selectOption'">
                <label  for="x.name" >{{x.caption}}</label>
                <select name="x.name" v-model="output['x.name']">
                    <option v-for="(y,index,key) in x.option" :value="y" >{{y}}</option>
                </select>
                </template>
            </span>
            <button type="submit" class="w3-button w3-teal w3-section">Simpan</button>
            <button type="reset" class="w3-button w3-reset w3-section">Reset</button>
            <button type="button" class="w3-button w3-blue w3-section" @click="toggleFormData()">Batal</button>
        </form>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import { Bus } from '../bus.js';

export default {
    name : 'genForm',
	props : {
		url : String,
		input : Array,
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
        Bus.$on('toggleFormData',()=>{
            this.toggleFormData()
            })
        Bus.$on('getDataDetail', x =>{
            this.getDataDetail(x)
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
		submitData (){
            if(this.output.id == undefined){
                var method = 'POST'
                var url = ""
            }else {
                var method = 'PUT'
                var url = '/'+this.output.id
            }
            var field = Object.keys(this.output)
            var field_length = field.length
            var output_new = {}
            for(var x=0;x<field_length;x++){
                if(field[x] != this.pk) output_new[field[x]] = this.output[field[x]]
                this.output[field[x]] = null
            }
			axios({
				method : method,
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
		},
        getDataDetail : function(x){
            axios.get('/api/'+this.url+'/'+x)
            .then(res=>{
                this.output = res.data.data[0]
                this.showForm = !this.showForm
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
