<template>
<div class="w3-modal" :style="showModal ? 'display:block;' : 'display:none;'">
    <div class="w3-modal-content w3-animate-top">
        <slot></slot>
    </div>
</div>
</template>

<script>
import { Bus } from '../bus.js';

export default {
    name : 'genModal',
	data () {
		return {
            showModal : false
		}
	},
    created () {
        Bus.$on('toggleModal',()=>{
            this.showModal = !this.showModal
            })
    }
}
</script>

<style scoped>

</style>
