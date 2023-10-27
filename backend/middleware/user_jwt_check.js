const jwt = require("jsonwebtoken");
const User = require("../models/user_model");

async function userTokenCheck(req, res, next) {
  if (
    req.headers.authorization &&
    req.headers.authorization.split(" ")[0] === "Bearer"
  ) {
    const token = req.headers.authorization.split(" ")[1];
    try {
      const decoded = jwt.decode(token);
      req.user = decoded;
      const result = await User.findOne({ where: { id: decoded["id"] } });
      if (!result) {
        return res.status(403).send({ success: false, data: "User not found" });
      }
      req.user = decoded;
      next();
    } catch (e) {
      return res
        .status(403)
        .send({ success: false, data: "Unauthenticated User" });
    }
  } else {
    return res
      .status(401)
      .send({ success: false, data: "Access Denied. No token provided." });
  }
}

module.exports = {
  userTokenCheck: userTokenCheck,
};
