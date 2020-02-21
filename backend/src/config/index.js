// configuration file for application variables. Can be modified to read in
// JSON, and parse that JSON instead, since it is the same thing
let postgreshostname = process.env.POSTGRES_HOSTNAME;
if (!postgreshostname) {
  postgreshostname = 'localhost';
}

let db_port = 5432
let db_name = 'rafflebay'

if (postgreshostname == 'postgres_test') {
  db_port = 5433
  db_name = 'rafflebay_test'
}
const config = {
  database: {
    user: 'postgres',
    password: 'admin',
    port: db_port,
    host: postgreshostname,
    database: db_name,
  },
  port: 31337,
  auth: {
    secret: 'rafflebay test secret',
    expirationTime: 86400,
    issuer: 'rafflebay',
  },
};

module.exports = config;
