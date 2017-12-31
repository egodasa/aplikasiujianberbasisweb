<template>
<div class="w3-section">
	<div style="margin:0 auto;width:75%;" class="w3-card w3-white">
		<div class="w3-container">
		<h1 class="w3-center">Petunjuk Pengerjaan Ujian</h1>
        <ul class="w3-large">
            <li>Pada halaman ujian, semua tombol dan menu sudah dibuat jelas dan sesuai fungsinya sehingga tidak perlu ragu untuk menekan tombol atau menu yang terdapat pada halaman ujian.</li>
            <li>Jika waktu ujian telah HABIS,maka ujian otomatis akan dikumpulkan dan semua jawaban peserta akan disimpan otomatis.</li>
            <li>Jika soal ujian adalah pilihan ganda :</li>
                <ol>
                    <li>Jawaban akan disimpan setiap peserta mengklik pilihan ganda yang diyakini sebagai jawaban yang benar</li>
                    <li>Jika ingin mengganti jawaban, bisa dilakukan dengan mengklik pilihan ganda yang lain pada soal tersebut.</li>
                </ol>
            <li>Jika soal ujian adalah essai :</li>
                <ol>
                    <li>Peserta menjawab pertanyaan essai dengan cara mengetik jawaban pada kotak jawaban yang sudah disediakan.</li>
                    <li>Jika sudah selesai mengetik jawaban, silahkan klik tombol "SIMPAN JAWABAN" dan jawaban akan tersimpan.</li>
                </ol>
            <li>Jika terdapat masalah maka dipersilahkan untuk melapor kepada pengawas ujian</li>
        </ul>
		</div>
        <div class="w3-row">
        <div class="w3-container w3-half">
			<button class="w3-button w3-margin w3-left w3-teal" @click="batalkanUjian"><b><< Kembali</b></button>
		</div>
        <div class="w3-container w3-half">
			<router-link :to="{name: 'pelaksanaanUjian'}" class="w3-button w3-margin w3-right w3-blue"><b>Kerjakan Ujian>></b></router-link>
		</div>
        </div>
	</div>
</div>

</template>

<script>

export default {
  name: 'petunjukUjian',
  methods : {
      batalkanUjian () {
          this.$lcs.removeLcs('infoLogin')
          this.$router.push({path: '/'})
      }
  }
}
</script>

<style scoped>

</style>
