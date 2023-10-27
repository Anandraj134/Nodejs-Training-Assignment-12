const { Sequelize } = require("sequelize");

const sequelize = new Sequelize({
    dialect: process.env.DB_DIALECT,
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    username: process.env.DB_USERNAME,  
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    logging: false,
  });
async function testDatabaseConnection(req, res) {
  try {
    await sequelize.authenticate();
    console.log("Database connection has been established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
    res.status(500).send("Unable to connect to the database");
  }
}

async function synchronizeDatabase(req, res) {
  try {
    await sequelize.sync();
    console.log("Database synchronized successfully.");
  } catch (error) {
    console.error("Unable to synchronize the database:", error);
    res.status(500).send("Unable to synchronize the database");
  }
}

module.exports = {
  sequelize: sequelize,
  testDatabaseConnection: testDatabaseConnection,
  synchronizeDatabase: synchronizeDatabase,
};
