<template>
<notifications>
<template slot="body" slot-scope="props">
<div class="w3-container">
  <template v-if="props.item.type == 'danger'">
  <div class="w3-panel w3-red w3-card w3-round" @click="props.close">
      <p><b>{{props.item.title}}</b></p>
    <p>{{props.item.text}}</p>
  </div>
  </template>
  <template v-else-if="props.item.type == 'warning'">
  <div class="w3-panel w3-yellow w3-card w3-round" @click="props.close">
      <p><b>{{props.item.title}}</b></p>
    <p>{{props.item.text}}</p>
  </div>
  </template>
  <template v-else-if="props.item.type == 'info'">
  <div class="w3-panel w3-blue w3-card w3-round" @click="props.close">
      <p><b>{{props.item.title}}</b></p>
    <p>{{props.item.text}}</p>
  </div>
  </template>
  <template v-else-if="props.item.type == 'success'">
  <div class="w3-panel w3-green w3-card w3-round" @click="props.close">
      <p><b>{{props.item.title}}</b></p>
    <p>{{props.item.text}}</p>
  </div>
  </template>
  <template v-else>
  <div class="w3-panel w3-pale-blue w3-card w3-round" @click="props.close">
      <p><b>{{props.item.title}}</b></p>
    <p>{{props.item.text}}</p>
  </div>
  </template>
</div>
</template>
</notifications>
</template>

<script>
import Notifications from 'vue-notification'
export default {
  name: 'pesan',
  components : {
      Notifications
      },
  methods : {
      showAlert (judul,isi,tipe) {
          this.$notify({
              title: judul,
              text: isi,
              duration : 5000,
              position : 'top right',
              type : tipe
            })
        }
  }
}
</script>
<style scoped>
    

</style>
