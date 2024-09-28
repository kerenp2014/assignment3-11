// before rum
//npm install express

// to run
// npm start

'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const OS = require('os');
const ENV = 'DEV';


// App
const app = express();
app.get('/', (req, res) => {
  res.statusCode = 200;
  const msg = 'Hello from Node 4! For SCTP-CE6-Mod3.11';
  res.send(msg);
});

app.get('/test', (req, res) => {
  res.statusCode = 200;
  const msg = 'Hello from /test Node! For SCTP-CE6-Mod3.11';
  res.send(msg);
});

const server = app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

module.exports = { app, server };