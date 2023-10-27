const User = require("../models/user_model");

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll();
    res.status(200).json({ success: true, data: users });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error fetching users." });
  }
};

// Update user information
exports.updateUser = async (req, res) => {
  try {
    const { username, email, bio, profile_picture_url, contact_details } =
      req.body;
    const userId = req.user.id;

    const user = await User.findByPk(userId);

    if (!user) {
      return res.status(404).json({ success: false, data: "User not found" });
    }

    user.username = username;
    user.email = email;
    user.bio = bio;
    user.profile_picture_url = profile_picture_url;
    user.contact_details = contact_details;

    await user.save();

    res.json({ success: true, data: user });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ success: false, data: "Error updating user information." });
  }
};
