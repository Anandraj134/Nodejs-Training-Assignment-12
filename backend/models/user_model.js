const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");
const BlogPost = require("./blog_model");
const Comment = require("./comment_model");
const Portfolio = require("./portfolio_model");

const User = sequelize.define("User", {
  username: {
    type: DataTypes.STRING,
    unique: true,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    unique: true,
    allowNull: false,
  },
  password: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  bio: DataTypes.TEXT,
  profile_picture_url: DataTypes.TEXT,
  contact_details: DataTypes.TEXT,
});

User.hasMany(BlogPost, { as: 'blogs' });
User.hasMany(Comment, { as: 'comments' });
User.hasMany(Portfolio, { as: 'portfolios' });

sequelize.sync();

module.exports = User;
