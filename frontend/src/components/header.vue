<template>
<!-- Top container -->
<div class="w3-bar w3-black w3-large w3-top w3-bottom-margin" style="z-index:4">
  <span class="w3-bar-item w3-left w3-hide-small w3-hide-medium"><img src="/images/upi.png" class="w3-image" style="max-height:30px;width:50px;" /> {{title}}</span>
  <button class="w3-bar-item w3-button w3-hide-large w3-hover-none w3-hover-text-light-grey" @click="toggleMenu()"><i class="fa fa-bars"></i>  Menu </button>
    <span class="w3-bar-item w3-right w3-hide-large"><img src="/images/upi.png" class="w3-image" style="max-height:30px;width:50px;" /> </span>
</div>
</template>
<script>
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
          bus.$emit('setMenu',3)
          this.$router.push({path: '/login'})
      },
      toggleMenu (){
          bus.$emit('toggleMenu')
      }
  }
}
</script>
<style scoped>

</style>
