const jwt = require("jsonwebtoken");
const User = require("../models/user_model");

async function userTokenCheck(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ success: false, data: "Access Denied. No token provided." });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.decode(token);
    if (!decoded || !decoded.id) {
      return res.status(403).json({ success: false, data: "Unauthenticated User" });
    }

    const user = await User.findByPk(decoded.id);
    if (!user) {
      return res.status(403).json({ success: false, data: "User not found" });
    }

    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ success: false, data: "Unauthenticated User" });
  }
}

module.exports = {
  userTokenCheck,
};
