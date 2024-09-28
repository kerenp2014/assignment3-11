// app.test.js
const request = require('supertest');
const {app, server} = require('../index');

afterAll((done) => {
  server.close();
  done();
})

describe('Express App', () => {
  test('GET / should return 200 and "Hello from Node 4! For SCTP-CE6-Mod3.11"', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('Hello from Node 4! For SCTP-CE6-Mod3.11');
  });

  test('GET /test should return 200 and "Hello from /test Node! For SCTP-CE6-Mod3.11"', async () => {
    const response = await request(app).get('/test');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('Hello from /test Node! For SCTP-CE6-Mod3.11');
  });

  test('GET /unknown should return 404', async () => {
    const response = await request(app).get('/unknown');
    expect(response.statusCode).toBe(404);
  });
});
