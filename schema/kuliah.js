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
    kuliah: {
      type: new GraphQLList(daftarKuliah),
      resolve(parentValue, args) {
        return db('lap_kuliah').select()
      }
    },
    cariKuliah: {
      type: new GraphQLList(daftarKuliah),
      args : {
          cari : {type : GraphQLString}
      },
      resolve(parentValue, args) {
        return db('lap_kuliah')
            .select(db.raw("*,array_to_string(nm_kelas,',') as ket_nm_kelas"))
            .where('id_kuliah','like','%'+args.cari+'%')
            .orWhere('nm_matkul','like','%'+args.cari+'%')
            .orWhere('nm_dosen','like','%'+args.cari.toUpperCase()+'%')
            .limit(20)
      }
    },
    detailKuliah: {
      type: new GraphQLList(daftarKuliah),
      args : {
          id_kuliah : {type : GraphQLString}
      },
      resolve(parentValue, args) {
        return db('lap_kuliah').select().where('id_kuliah',args.id_kuliah)
      }
    },
    statusKuliah: {
      type: new GraphQLList(daftarKuliah),
      args : {
          status : {type : GraphQLInt}
      },
      resolve(parentValue, args) {
        return db('lap_kuliah').select().where('status_kuliah',args.status)
      }
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
