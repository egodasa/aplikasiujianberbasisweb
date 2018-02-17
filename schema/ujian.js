const {
  GraphQLObjectType,
  GraphQLString,
  GraphQLInt,
  GraphQLSchema,
  GraphQLList,
  GraphQLNonNull,
  GraphQLBoolean,
  GraphQLScalarType
} = require('graphql');
/*
const daftarUjian = new GraphQLObjectType({
  name: 'Ujian',
  fields: () => ({
    id_ujian
    hari
    mulai
    selesai
    deskripsi
    status_ujian
    nm_status_ujian
    id_jsoal
    nm_jsoal
    id_jujian
    nm_jujian
    id_kuliah
    kd_matkul
    nm_matkul
    nidn
    nm_dosen
    id_kelas
    nm_kelas
    tahun_akademik
  })
});*/
const daftarPeserta = new GraphQLObjectType({
  name: 'daftarPeserta',
  fields: () => ({
    nobp: { 
        type: GraphQLString
    },
    nm_mahasiswa: { type: GraphQLString },
    nm_kelas: { type: GraphQLString }
  })
});
const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  fields: {
    detailPesertaUjian: {
      type: new GraphQLList(daftarPeserta),
      args : {
          id : { type : GraphQLString},
          nobp : { type : GraphQLString}
      },
      resolve(parentValue, args) {
        return db('lap_peserta_ujian').select().where({id_ujian:args.id,nobp:args.nobp})
      }
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
