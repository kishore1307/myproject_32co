const AWS = require('aws-sdk')
const ssm = new AWS.SSM()

async function getSecret(name) {
  const res = await ssm.getParameter({ Name: name, WithDecryption: true }).promise()
  return res.Parameter.Value
}

module.exports = { getSecret }
