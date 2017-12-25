export const auth = {
    beforeRouteEnter (to, from, next) {
      next(vm => {
            if(vm.$lcs.has('user')){
                if(vm.$lcs.get('user').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$lcs.get('user').username})
                else vm.$router.push({path:'/'})
            }
        })
    }
}
