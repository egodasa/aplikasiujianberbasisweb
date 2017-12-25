var query,kueri,url,name
                            if(hasil[0].id_juser != 0){
                                if(hasil[0].id_juser == 2){
                                    query = `query getDosen(id : String){getDosen(id : $id){id_dosen,nidn,nm_dosen}}`
                                    kueri = {query : query,variables : {id : hasil[0].username}}
                                    url = 'api/v2/dosen'
                                }else if(hasil[0].id_juser == 3){
                                    query = `query getMahasiswa(id : String){getMahasiswa(id : $id){id_mahasiswa,nobp,nm_mahasiswa}}`
                                    kueri = {query : query,variables : {id : hasil[0].username}}
                                    url = 'api/v2/mahasiswa'
                                }
                                return this.$ajx.post(url,kueri)
                            }