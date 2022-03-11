const { Client } = require('pg');

const client = new Client({
    host: 'localhost',
    port: 9999,
    database: 'postgres',
    user: 'postgres',
    password: 'postgres',
});

client.connect(err => {
    if (err) {
      console.error('connection error', err.stack)
    } else {
      console.log('connected')
    }
});

client.query('SELECT $1::text as message', ['Hello world!'], (err, res) => {
  console.log(err ? err.stack : res.rows[0].message) // Hello World!
  client.end()
})