<template>
    <div class="w3-container">
        <h2>Pengaturan</h2>
        <span class="w3-container">
                <label>Tahun Akademik</label>
                <input type="text" class="w3-input w3-border" v-model="tahun" />
            </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'pengaturan',
  components : {
      genTable, genForm
  },
  data () {
      return {
          tahun : null
        }
  },
  created () {
        
  },
  methods : {
        
  }
}
</script>

<style scoped>

</style>
