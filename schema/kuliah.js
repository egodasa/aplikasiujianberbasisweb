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
    nm_dosen: { type: GraphQLString },
    tahun_akademik: { type: GraphQLString },
    status_kuliah: { type: GraphQLInt },
    nm_status_kuliah: { type: GraphQLString }
  })
});
const hasil = new GraphQLScalarType({
  name: 'Hasil',
  serialize: value => value,
  parseValue: value => value,
  parseLiteral: (ast) => {
    if (ast.kind !== Kind.OBJECT) {
      throw new GraphQLError(
        `Query error: Can only parse object but got a: ${ast.kind}`, 
        [ast],
      );
    }
    return ast.value;
  },
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
