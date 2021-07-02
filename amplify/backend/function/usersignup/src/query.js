module.exports = {
    mutation: `mutation createUser($input: CreateUserInput!) {
      createUser(input: $input) {
        id
        name
        username
      }
    }
    `
}