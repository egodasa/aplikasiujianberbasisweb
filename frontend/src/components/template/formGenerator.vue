<template>
<div id="genForm">
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content">
        <div class="w3-card-8 w3-container w3-section">
        <template v-if="contentType == 'form'">
            <form v-if="showForm" id="addData" @submit.prevent="submitData()" name="addData" method="POST">
                <h3>Tambah Data</h3>
                <span v-for="x in input">
                    <template v-if="x.jenis == 'textField'">
                        <template v-if="x.tipe == 'number'">
                            <label>{{x.caption}}</label>
                            <input v-validate data-vv-rules="required" v-bind:data-vv-as="x.caption" class="w3-input w3-border" :placeholder="x.caption" type="number" :name="x.name" :min="x.min" :max="x.max" v-model.number="output[x.name]" />
                            <span class="w3-text-red" v-if="errors.has(x.name)">{{ errors.first(x.name) }}</span>
                        </template>
                        <template v-else-if="x.tipe == 'email'">
                            <label>{{x.caption}}</label>
                            <input v-validate data-vv-rules="required" v-bind:data-vv-as="x.caption" class="w3-input w3-border" v-validate="'required'"  :placeholder="x.caption" type="email" :name="x.name" v-model="output[x.name]" />
                            <span class="w3-text-red" v-if="errors.has(x.name)">{{ errors.first(x.name) }}</span>
                        </template>
                        <template v-else>
                            <label>{{x.caption}}</label>
                            <input v-validate data-vv-rules="required" v-bind:data-vv-as="x.caption" class="w3-input w3-border" v-validate="'required'" :placeholder="x.caption" type="text" :name="x.name" v-model="output[x.name]" />
                            <span class="w3-text-red" v-if="errors.has(x.name)">{{ errors.first(x.name) }}</span>
                        </template>
                        <br/>
                    </template>
                    <template v-else-if="x.jenis == 'textArea'">
                    <label>{{x.caption}}</label>
                    <textarea v-validate data-vv-rules="required" v-bind:data-vv-as="x.caption" class="w3-input w3-border" :placeholder="x.caption" :name="x.name" v-model="output[x.name]" />{{x.value}}</textarea>
                    <span class="w3-text-red" v-if="errors.has(x.name)">{{ errors.first(x.name) }}</span>    
                    </template>
                    <template v-else-if="x.jenis == 'radioButton'">
                    <label for="x.name" v-for="(y,index,key) in x.option">
                        <span v-if="index < 1">{{x.caption}}<br/></span>
                        <input class="w3-radio" v-validate data-vv-rules="required" :value="y[x.valueSelect]" v-bind:data-vv-as="x.caption" type="radio" :name="x.name" v-model="output[x.name]" /> {{y[x.captionSelect]}}<br/>
                    </label>
                    <span class="w3-text-red" v-if="errors.has(x.name)">{{ errors.first(x.name) }}</span>
                    </template>
                    <template v-else-if="x.jenis == 'selectOption'">
                    <label>{{x.caption}}</label>
                    <select class="w3-select w3-white w3-border w3-text-gray" v-validate data-vv-rules="required" v-bind:data-vv-as="x.caption" :name="x.name" v-model="output[x.name]">
                        <template v-if="x.option.length == 0">
                        <option class="w3-white w3-text-gray" value="null" disabled>{{x.caption}}</option>
                        </template>
                        <template v-else>
                            <template v-for="(y,index,key) in x.option">
                                <template v-if="index == 0">
                                <option class="w3-white w3-text-gray" value="null" disabled>{{x.caption}}</option>
                                <option :value="y[x.valueSelect]">{{y[x.captionSelect]}}</option>
                                </template>
                                <template v-else>
                                <option :value="y[x.valueSelect]">{{y[x.captionSelect]}}</option>
                                </template>
                            </template>
                        </template>
                    </select>
                    <span class="w3-text-red" v-if="errors.has(x.name)">{{ errors.first(x.name) }}</span><br/>
                    </template>
                    <template v-else-if="x.jenis == 'select2'">
                        <v-select :valueSelect="x.valueSelect" v-model="output[x.name]" :label="x.captionSelect" :placeholder="x.placeholder" :options="x.option"></v-select>
                    </template>
                    <template v-else-if="x.jenis == 'richEditor'">
                        <wysiwyg v-model="output[x.name]" />
                    </template>
                    <template v-else-if="x.jenis == 'datePick'">
                        <label>{{x.caption}}</label>
                        <datepicker v-model="output[x.name]"></datepicker>
                    </template>
                    <template v-else-if="x.jenis == 'timePick'">
                        <label>{{x.caption}}</label>
                        <time-picker v-model="output[x.name]"></time-picker>
                    </template>
                <br/>
                </span>
                <button type="submit" :disabled="Bsimpan.disabled" class="w3-button w3-teal w3-section"><span v-html="Bsimpan.caption"></span></button>
                <button type="reset" class="w3-button w3-reset w3-red w3-section" :disabled="Breset.disabled"><span v-html="Breset.caption"></span></button>
                <button type="button" class="w3-button w3-blue w3-section" @click="toggleFormData()" :disabled="Bbatal.disabled"><span v-html="Bbatal.caption"></span></button>
            </form>
        </template>
        <template v-else>
            <slot></slot>
        </template>
        </div>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import { Bus } from '../../bus.js';
import Datepicker from 'vuejs-datepicker';
import TimePicker from 'vue-timepicker'

export default {
    name : 'genForm',
	props : {
		url : String,
		input : Array,
        pk : {
            type : String,
            required : false,
            default : 'id'
        },
        contentType : {
            type : String,
            required : false,
            default : "form"
        }
	},
	data () {
		return {
            showForm : false,
            idData : null,
            output : {},
              Bsimpan : {
                  disabled : false,
                  caption : '<i class="fa fa-save w3-small"></i> Simpan',
              },
              Bbatal : {
                  disabled : false,
                  caption : '<i class="fa fa-remove w3-small"></i> Batal'
              },
              Breset : {
                  disabled : false,
                  caption : '<i class="fa fa-repeat w3-small"></i> Reset'
              }
		}
	},
    components: {
        Datepicker, TimePicker
    },
    created () {
        Bus.$on('getDataDetail', x =>{
            this.getDataDetail(x)
        })
        Bus.$on('toggleFormData', () =>{
            this.toggleFormData()
        })
        this.showForm = false
    },
	methods : {
        buttonSubmit (x) {
            if(x == 1){
                Bsimpan.disabled = true
                Bsimpan.caption = '<i class="fa fa-spinner w3-spin w3-small"></i> Menyimpan Data'
                Breset.disabled = true
                Bbatal.disabled = true
            }else{
                Bsimpan.disabled = false
                Bsimpan.caption = 'Simpan'
                Breset.disabled = false
                Bbatal.disabled = false
            }
        },
        toggleFormData (){
            this.showForm = !this.showForm
        },
		submitData (){
            if(this.output[this.pk] == undefined){
                var method = 'POST'
                var url = ""
            }else {
                var method = 'PUT'
                var url = '/'+this.output[this.pk]
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
                console.log('pantek')
				if(res.data.status == false) {
                    console.log(res.data)
                    this.output[this.pk] = undefined
                }
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
	},
    destroyed () {
        //Bus.$off('getDataDetail')
    }
}
</script>

<style scoped>

</style>
