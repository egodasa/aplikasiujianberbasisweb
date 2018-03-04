<template>
    
<div class="w3-container">
    <h2>Daftar User</h2>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :tableContent="tableContent"></gen-table>
</div>

</template>

<script>
import genTable from '../../components/GenTable.vue'
import genForm from '../../components/formGenerator.vue'
import admin from './halamanAdmin.vue'

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
            tableContent : [
                {name:"id_user",show:false,caption:null},
                {name:"username",show:true,caption:"Username"},
                {name:"nm_juser",show:true,caption:"Jenis User"}
            ]
        }
  },
  created (){
      this.getDataSelect('./api/jenis_user',2)
  },
  methods : {
      getDataSelect (url,target) {
          this.$ajx.get(url)
          .then(res=>{
              this.listForm[target].option = res.data.data
              })
          .catch(err=>{
              this[target] = []
              
              })
      }
  }
}
</script>

<style scoped>

</style>
