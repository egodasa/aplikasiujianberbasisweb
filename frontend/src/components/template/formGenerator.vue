<template>
<div id="genForm">
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content">
        <div class="w3-card-8 w3-container w3-section">
        <template v-if="contentType == 'form'">
            <form v-if="showForm" id="addData" @submit.prevent="submitData()" name="addData" method="POST">
                <h3>{{edit ? 'Edit Data' : 'Tambah Data'}}</h3>
                <span v-for="x in input">
                    <template v-if="x.jenis == 'textField'">
                        <template v-if="x.tipe == 'number'">
                            <label>{{x.caption}}</label>
                            <input :disabled="x.disabled || false" class="w3-input w3-border" :placeholder="x.caption" type="number" :name="x.name" :min="x.min" :max="x.max" v-model.number="output[x.name]" />
                            <span class="w3-text-red">{{ error[x.name] }}</span>
                        </template>
                        <template v-else-if="x.tipe == 'email'">
                            <label>{{x.caption}}</label>
                            <input :disabled="x.disabled || false" class="w3-input w3-border"  :placeholder="x.caption" type="email" :name="x.name" v-model="output[x.name]" />
                            <span class="w3-text-red">{{ error[x.name] }}</span>
                        </template>
                        <template v-else>
                            <label>{{x.caption}}</label>
                            <input :disabled="x.disabled || false" class="w3-input w3-border" :placeholder="x.caption" :type="x.tipe" :name="x.name" v-model="output[x.name]" />
                            <span class="w3-text-red">{{ error[x.name] }}</span>
                        </template>
                        <br/>
                    </template>
                    <template v-else-if="x.jenis == 'textArea'">
                    <label>{{x.caption}}</label>
                    <textarea :disabled="x.disabled || false" class="w3-input w3-border" :placeholder="x.caption" :name="x.name" v-model="output[x.name]" />{{x.value}}</textarea>
                    <span class="w3-text-red">{{ error[x.name] }}</span>    
                    </template>
                    <template v-else-if="x.jenis == 'radioButton'">
                    <label for="x.name" v-for="(y,index,key) in x.option">
                        <span v-if="index < 1">{{x.caption}}<br/></span>
                        <input class="w3-radio" :disabled="x.disabled || false" :value="y[x.valueSelect]" type="radio" :name="x.name" v-model="output[x.name]" /> {{y[x.captionSelect]}}<br/>
                    </label>
                    <span class="w3-text-red">{{ error[x.name] }}</span>
                    </template>
                    <template v-else-if="x.jenis == 'selectOption'">
                    <label>{{x.caption}}</label>
                    <select class="w3-select w3-white w3-border w3-text-gray" :disabled="x.disabled || false" :name="x.name" v-model="output[x.name]">
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
                    <span class="w3-text-red">{{ error[x.name] }}</span><br/>
                    </template>
                    <template v-else-if="x.jenis == 'select2'">
                        <v-select :valueSelect="x.valueSelect" v-model="output[x.name]" :label="x.captionSelect" :placeholder="x.placeholder" :options="x.option"></v-select>
                        <span class="w3-text-red">{{ error[x.name] }}</span> 
                    </template>
                    <template v-else-if="x.jenis == 'richEditor'">
                        <wysiwyg v-model="output[x.name]" />
                        <span class="w3-text-red">{{ error[x.name] }}</span> 
                    </template>
                    <template v-else-if="x.jenis == 'datePick'">
                        <label>{{x.caption}}</label>
                        <datepicker input-class="w3-input w3-border" v-model="output[x.name]"></datepicker>
                        <span class="w3-text-red">{{ error[x.name] }}</span> 
                    </template>
                    <template v-else-if="x.jenis == 'timePick'">
                        <label>{{x.caption}}</label>
                        <time-picker v-model="output[x.name]"></time-picker>
                        <span class="w3-text-red">{{ error[x.name] }}</span> 
                    </template>
                    <template v-else-if="x.jenis == 'selectize'">
                        <label>{{x.caption}}</label>
                        <selectize v-model="output[x.name]" :settings="x"></selectize>
                        <span class="w3-text-red">{{ error[x.name] }}</span> 
                    </template>
                <br/>
                </span>
                <button type="submit" :disabled="Bsimpan.disabled" class="w3-button w3-teal w3-section"><span v-html="Bsimpan.caption"></span></button>
                <button type="reset" @click="resetForm()" class="w3-button w3-reset w3-red w3-section" :disabled="Breset.disabled"><span v-html="Breset.caption"></span></button>
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
import Datepicker from 'vuejs-datepicker';
import TimePicker from 'vue-timepicker'
import pengaturan from '../../pengaturan.json'

import selectize from 'vue2-selectize'

export default {
    name : 'genForm',
    components : {
        selectize, Datepicker, TimePicker
    },
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
            msg : pengaturan,
            showForm : false,
            idData : null,
            output : {},
            error : {},
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
              },
              edit : false
		}
	},
    created () {
        bus.$on('getDataDetail', x =>{
            this.getDataDetail(x)
        })
        bus.$on('toggleFormData', () =>{
            this.toggleFormData()
        })
        this.showForm = false
        _.forEach(this.input,(v,k)=>{
            this.$set(this.error,v.name, null)
            })
        //SET DAFTAR V-MODEL DI OBJECT OUTPUT{}
        _.forEach(this.input,(v,k)=>{
            this.output[v.name] = null //looping ke object input dan ambil properti name yang merupakan vmodel
            this.error[v.name] = null //looping ke object input dan ambil properti name yang merupakan error
            })
        //EOF SET DAFTAR V-MODEL DI OBJECT OUTPUT{}
    },
	methods : {
        resetForm (){
            var prop = Object.keys(this.error)
            _.forEach(prop, (v,k)=>{
                this.error[v] = null
                this.output[v] = null
                })
        },
        resetError () {
            var prop = Object.keys(this.error)
            _.forEach(prop, (v,k)=>{
                this.error[v] = null
                })
        },
        buttonSubmit (x) {
            if(x == 1){
                this.Bsimpan.disabled = true
                this.Bsimpan.caption = '<i class="fa fa-spinner w3-spin w3-small"></i> Menyimpan Data'
                this.Breset.disabled = true
                this.Bbatal.disabled = true
            }else{
                this.Bsimpan.disabled = false
                this.Bsimpan.caption = '<i class="fa fa-save w3-small"></i> Simpan'
                this.Breset.disabled = false
                this.Bbatal.disabled = false
            }
        },
        toggleFormData (){
            this.showForm = !this.showForm
            this.resetForm()
            this.buttonSubmit(0)
        },
		submitData (){
            this.buttonSubmit(1)
            this.resetError()
            if(this.edit == false){
                var method = 'POST'
                var url = ""
            }else {
                var method = 'PUT'
                var url = '/'+this.output[this.pk]
                this.edit = false
            }
			ajx({
				method : method,
				data : this.output,
				url :'/api/'+this.url+url,
				})
			.then(res=>{
                bus.$emit('newData')
                this.toggleFormData()
                this.buttonSubmit(0)
			})
			.catch(err=>{
                var kode = err.response.status 
                if(kode == 422){
                    var listError = Object.keys(err.response.data.error)
                    _.forEach(listError,(v,k)=>{
                        this.error[v] = err.response.data.error[v].msg
                        })
                }else if(kode >= 500){
                    bus.$emit('showAlert','Kesalahan!','Terjadi kesalahan pada server.','bottom right','danger')
                }
                this.buttonSubmit(0)
			})
		},
        getDataDetail (x){
            this.edit = true
            ajx.get('/api/'+this.url+'/'+x)
            .then(res=>{
                this.output = res.data.data[0]
                this.showForm = !this.showForm
            })
            .catch(err=>{
                bus.$emit('showAlert','Peringatan!','Tidak dapat mengambil data. Silahkan ulangi kembali.','warning')
            })
		}
	},
    destroyed () {
        //bus.$off('getDataDetail')
    }
}
</script>

<style scoped>

</style>
