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
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
