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
    mahasiswa: {
      type: new GraphQLList(daftarMahasiswa),
      resolve(parentValue, args) {
        return db('tbmahasiswa').select()
      }
    },
    mahasiswaNotInKelasUjian: {
      type: new GraphQLList(daftarMahasiswa),
      args : {
          id_ujian : {
              type : GraphQLString
          },
          id_kelas : {
              type : GraphQLInt
          }
      },
      resolve(parentValue, args) {
        return db('tbmahasiswa').select()
        .whereNotIn("nobp",db.raw("select nobp from lap_peserta_ujian where id_kelas=? and id_ujian=?",[args.id_kelas,args.id_ujian]))
            .where("status_mahasiswa",1).orderBy("nm_mahasiswa","asc")
      }
    }
  }
});
module.exports = new GraphQLSchema({
  query: RootQuery,
});
