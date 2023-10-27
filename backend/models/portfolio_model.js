const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Portfolio = sequelize.define("Portfolio", {
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description: {
    type: DataTypes.TEXT,
  },
  technologiesUsed: {
    type: DataTypes.STRING,
  },
  githubLink: {
    type: DataTypes.STRING,
  },
});

sequelize.sync();

module.exports = Portfolio;
