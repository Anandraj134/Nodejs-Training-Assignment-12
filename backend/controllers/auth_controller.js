const User = require("../models/user_model");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

exports.signup = async (req, res) => {
  try {
    const { username, email, password } = req.body;
    const salt = await bcrypt.genSalt(Number(process.env.BCRYPT_SALT));
    const hashedPassword = await bcrypt.hash(password, salt);

    const findemail = await User.findOne({ where: { email } });
    const findUserame = await User.findOne({ where: { username } });
    if (findemail) {
      return res
        .status(409)
        .json({ success: false, data: "Email already exists." });
    }
    if (findUserame) {
      return res
        .status(409)
        .json({ success: false, data: "Username already exists." });
    }

    const user = await User.create({
      username,
      email,
      password: hashedPassword,
    });

    const token = jwt.sign({ id: user.id }, process.env.JWTKEY);

    res.json({ success: true, data: user, token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: true, data: "Error during signup." });
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
      return res.status(401).json({ data: "Invalid password." });
    }

    const token = jwt.sign({ id: user.id }, process.env.JWTKEY);

    res.json({ success: true, data: user, token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: true, data: "Error during login." });
  }
};
