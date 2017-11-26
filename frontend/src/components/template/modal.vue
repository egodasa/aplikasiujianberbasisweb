<template>
<div class="w3-modal">
  <div class="w3-modal-content">
    <header class="w3-container w3-teal">
    <span class="w3-closebtn">&times;</span>
      <slot name="header"></slot>
    </header>

    <div class="w3-container">
      <slot name="content"></slot>
    </div>

    <footer class="w3-container w3-teal">
      <slot name="footer"></slot>
    </footer>

  </div>
</div>
</template>

<script>

export default {
  name: 'modal',
  data () {
      return {
          
        }
  }
}
</script>

<style scoped>

</style>
