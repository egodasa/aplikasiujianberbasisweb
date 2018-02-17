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

const daftarJujian = new GraphQLObjectType({
  name: 'Jujian',
  fields: () => ({
    id_jujian: { 
        type: GraphQLInt
    },
    nm_jujian: { type: GraphQLString }
  })
});
const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  fields: {
    jenis_ujian: {
      type: new GraphQLList(daftarJujian),
      resolve(parentValue, args) {
        return db('tbjenis_ujian').select()
      }
    },
    jenisUjianTersedia: {
      type: new GraphQLList(daftarJujian),
      args : {
          id_kuliah : {
              type : GraphQLString
          }
      },
      resolve(parentValue, args) {
        return db('tbjenis_ujian').select()
        .whereNotIn("id_jujian",db.raw("select id_jujian from tbujian where id_kuliah=?",[args.id_kuliah]))
      }
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
