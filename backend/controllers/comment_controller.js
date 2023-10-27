const Comment = require("../models/comment_model");

exports.createComment = async (req, res) => {
  try {
    const { content, blog_id } = req.body;

    const comment = await Comment.create({
      content,
      BlogId: blog_id,
      UserId: req.user.id,
    });

    res.status(200).json({ success: true, data: comment });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error creating Comment." });
  }
};

exports.getComment = async (req, res) => {
  try {
    const BlogId = req.params.id;
    const blogComment = await Comment.findAll({ where: { BlogId } });
    if (!blogComment) {
      return res
        .status(200)
        .json({ success: true, data: "Comment not found." });
    }
    return res.json({ success: true, data: blogComment });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error fetching Comment." });
  }
};
