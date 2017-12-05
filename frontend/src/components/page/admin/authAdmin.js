export const auth = {
    beforeRouteEnter (to, from, next) {
      next(vm => {
            if(vm.$session.has('user')){
                if(vm.$session.get('user').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$session.get('user').username})
                else vm.$router.push({path:'/'})
            }
        })
    }
}
