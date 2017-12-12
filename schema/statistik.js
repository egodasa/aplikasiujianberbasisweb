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
