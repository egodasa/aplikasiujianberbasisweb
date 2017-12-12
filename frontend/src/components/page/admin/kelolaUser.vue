<template>
    
<div class="w3-container">
    <h2>Daftar User</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import axios from 'axios'
export default {
  name: 'kelolaUser',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'user',
            listForm : [
                {
					caption: "Username",
					name:"username",
					jenis:"textField",
					tipe:"text",
					value:null
					},
                {
					caption: "Password",
					name:"password",
					jenis:"textField",
					tipe:"password",
					value:null
					},
                {
					caption: "Jenis User",
					name:"id_juser",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    option : [],
                    captionSelect : 'nm_juser',
                    valueSelect : 'id_juser'
					}
			],
            tableContent : {
                header :  ['Username','Jenis User'],
                content : ['id_user','username','nm_juser']
            }
        }
  },
  created (){
      this.getDataSelect('api/jenis_user',2)
  },
  methods : {
      getDataSelect (url,target) {
          axios.get(url)
          .then(res=>{
              this.listForm[target].option = res.data.data
              })
          .catch(err=>{
              this[target] = []
              console.log(err)
              })
      }
  }
}
</script>

<style scoped>

</style>
