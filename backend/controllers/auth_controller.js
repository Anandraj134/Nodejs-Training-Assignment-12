const User = require("../models/user_model");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const BCRYPT_SALT_ROUNDS = Number(process.env.BCRYPT_SALT);
const JWT_SECRET = process.env.JWTKEY;

const createToken = (user) => {
  return jwt.sign({ id: user.id }, JWT_SECRET);
};

exports.signup = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const existingEmail = await User.findOne({ where: { email } });
    const existingUsername = await User.findOne({ where: { username } });

    if (existingEmail) {
      return res.status(409).json({ success: false, data: "Email already exists." });
    }

    if (existingUsername) {
      return res.status(409).json({ success: false, data: "Username already exists." });
    }

    const hashedPassword = await bcrypt.hash(password, BCRYPT_SALT_ROUNDS);
    const user = await User.create({
      username,
      email,
      password: hashedPassword,
    });

    const token = createToken(user);

    res.status(200).json({ success: true, data: user, token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error during signup." });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ where: { email } });

    if (!user) {
      return res.status(404).json({ success: false, data: "User not found." });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({ success: false, data: "Invalid password." });
    }

    const token = createToken(user);

    res.status(200).json({ success: true, data: user, token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error during login." });
  }
};
