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

const daftarDosen = new GraphQLObjectType({
  name: 'Dosen',
  fields: () => ({
    id_dosen: { 
        type: GraphQLInt
    },
    nidn: { 
        type: GraphQLString
    },
    nm_dosen: { type: GraphQLString },
    status_dosen: { type: GraphQLInt }
  })
});
const daftarKuliah = new GraphQLObjectType({
  name: 'Kuliah',
  fields: () => ({
    id_kuliah: { 
        type: GraphQLString
    },
    kd_matkul: { type: GraphQLString },
    nm_matkul: { type: GraphQLString },
    nidn: { type: GraphQLString },
    nm_dosen: { type: GraphQLString },
    tahun_akademik: { type: GraphQLString },
    status_kuliah: { type: GraphQLInt },
    nm_status_kuliah: { type: GraphQLString },
    ket_nm_kelas : {type: GraphQLString}
  })
});
const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  fields: {
    dosen: {
      type: new GraphQLList(daftarDosen),
      resolve(parentValue, args) {
        return db('tbdosen').select()
      }
    },
    getDosen: {
      type: new GraphQLList(daftarDosen),
      args : {
          id : {
              type : GraphQLString
          }
      },
      resolve(parentValue, args) {
        return db('tbdosen').select().where('nidn',args.id)
      }
    },
    getKuliah: {
      type: new GraphQLList(daftarKuliah),
      args : {
          nidn : {type : GraphQLString}
      },
      resolve(parentValue, args) {
        return db('lap_kuliah')
            .select(db.raw("*,array_to_string(nm_kelas,',') as ket_nm_kelas"))
            .where('nidn',args.nidn)
      }
    },
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
