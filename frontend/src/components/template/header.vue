<template>
<!-- Top container -->
<div class="w3-bar w3-black w3-large" style="z-index:4">
  <span class="w3-bar-item w3-left w3-hide-small">{{title}}</span>
  <button class="w3-bar-item w3-button w3-hide-large w3-hover-none w3-hover-text-light-grey" @click="toggleMenu()"><i class="fa fa-bars"></i>  Menu</button>
</div>
</template>
<script>
import { Bus } from '../../bus.js';
export default {
  name: 'secHeader',
  props : {
      title : {
          type : String,
          required : false,
          default : 'Universitas Putra Indonesia YPTK Padang'
      },
      onTop : {
          type : Boolean,
          required : false,
          default : true
      }
  },
  methods : {
      logout () {
          this.$session.destroy()
          Bus.$emit('setMenu',3)
          this.$router.push({path: '/login'})
      },
      toggleMenu (){
          Bus.$emit('toggleMenu')
      }
  }
}
</script>
<style scoped>

</style>
