require("dotenv").config();
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

const sequelize = require("./config/database");
const authRoutes = require("./routes/auth_routes");
const userRoutes = require("./routes/user_routes");
const blogRoutes = require("./routes/blog_routes");
const commentRoutes = require("./routes/comment_routes");
const portfolioRoutes = require("./routes/portfolio_routes");
const contactUsRoutes = require("./routes/contact_form_routes");
const { userTokenCheck } = require("./middleware/user_jwt_check");

app.use(express.json());

app.use("/auth", authRoutes);
app.use("/user", userTokenCheck, userRoutes);
app.use("/blog", userTokenCheck, blogRoutes);
app.use("/comment", userTokenCheck, commentRoutes);
app.use("/portfolio", userTokenCheck, portfolioRoutes);
app.use("/contact_form", contactUsRoutes);

app.listen(port, async () => {
  sequelize.testDatabaseConnection();
  console.log(`Server Started on ${port}`);
});
