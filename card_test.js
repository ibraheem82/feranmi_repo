const { MongoClient } = require('mongodb');

const makeCard = () => '4' + Array.from({ length: 15 }, () => Math.floor(Math.random() * 10)).join('');

async function run() {
  const client = await MongoClient.connect('mongodb://localhost:27017');
  await client.db('testdb').collection('cards').insertOne({ cardNumber: makeCard(), createdAt: new Date() });
  console.log('Test card saved to MongoDB');
  await client.close();
}
run();