<template>
<div class="w3-section">
	<div class="w3-center" style="margin:0 auto;width:75%;">
		<div class="w3-container w3-pale w3-center">
		<h1>Petunjuk Pengerjaan Ujian</h1>
		Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimad minim veniam, quis nostrud exercitation ullamco laboris nisi utaliquip ex ea commodo consequat. Duis aute irure dolor inreprehenderit in voluptate velit esse cillum dolore eu fugiat nullapariatur. Excepteur sint occaecat cupidatat non proident, sunt inculpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimad minim veniam, quis nostrud exercitation ullamco laboris nisi utaliquip ex ea commodo consequat. Duis aute irure dolor inreprehenderit in voluptate velit esse cillum dolore eu fugiat nullapariatur. Excepteur sint occaecat cupidatat non proident, sunt inculpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimad minim veniam, quis nostrud exercitation ullamco laboris nisi utaliquip ex ea commodo consequat. Duis aute irure dolor inreprehenderit in voluptate velit esse cillum dolore eu fugiat nullapariatur. Excepteur sint occaecat cupidatat non proident, sunt inculpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimad minim veniam, quis nostrud exercitation ull
		</div>
		<div class="w3-container">
			<button class="w3-button w3-margin w3-left w3-teal" @click="batalkanUjian"><< Batalkan Ujian</button>
			<router-link :to="{name: 'pelaksanaanUjian'}" class="w3-button w3-margin w3-right w3-blue">Kerjakan Ujian>></router-link>
		</div>
	</div>
</div>

</template>

<script>

export default {
  name: 'petunjukUjian',
  methods : {
      batalkanUjian () {
          this.$session.destroy()
          this.$router.push({path: '/ujian/login'})
      }
  }
}
</script>

<style scoped>

</style>
