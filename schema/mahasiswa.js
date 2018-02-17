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

const daftarMahasiswa = new GraphQLObjectType({
  name: 'Mahasiswa',
  fields: () => ({
    id_mahasiswa: { 
        type: GraphQLInt
    },
    nobp: { 
        type: GraphQLString
    },
    nm_mahasiswa: { type: GraphQLString },
    status_mahasiswa: { type: GraphQLInt }
  })
});
const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  fields: {
    mahasiswa: {
      type: new GraphQLList(daftarMahasiswa),
      resolve(parentValue, args) {
        return db('tbmahasiswa').select()
      }
    },
    getMahasiswa: {
      type: new GraphQLList(daftarMahasiswa),
      args : {
          id : {
              type : GraphQLString
          }
      },
      resolve(parentValue, args) {
        return db('tbmahasiswa').select().where('nobp',args.id)
      }
    },
    mahasiswaNotInKelasKuliah: {
      type: new GraphQLList(daftarMahasiswa),
      args : {
          id_kuliah : {
              type : GraphQLString
          },
          nobp : {
              type : GraphQLString
          },
          nm_mahasiswa : {
              type : GraphQLString
          }
      },
      resolve(parentValue, args) {
        return db('tbmahasiswa').select()
        .whereNotIn("nobp",db.raw("select nobp from lap_peserta_kuliah where id_kuliah=?",[args.id_kuliah]))
            .where("status_mahasiswa",1).orderBy("nm_mahasiswa","asc").limit(20)
      }
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
