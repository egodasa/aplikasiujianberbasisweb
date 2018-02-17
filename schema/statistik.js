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

const daftarStatistik = new GraphQLObjectType({
  name: 'Statistik',
  fields: () => ({
    total_ujian: { 
        type: GraphQLInt
    },
    total_kuliah: { 
        type: GraphQLInt
    },
    total_dosen: { 
        type: GraphQLInt
    },
    total_mahasiswa: { 
        type: GraphQLInt
    }
  })
});
const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  fields: {
    statistik : {
      type: new GraphQLList(daftarStatistik),
      resolve(parentValue, args) {
        return db('statistik').select()
      }
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
