const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");
const Comment = require("./comment_model");

const Blogs = sequelize.define("Blogs", {
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  imageUrl: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  category: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

Blogs.hasMany(Comment, { as: 'comments' });
sequelize.sync();

module.exports = Blogs;
