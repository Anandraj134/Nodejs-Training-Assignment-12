const Comment = require("../models/comment_model");

exports.createComment = async (req, res) => {
  try {
    const { content, blog_id } = req.body;

    const comment = await Comment.create({
      content,
      BlogId: blog_id,
      UserId: req.user.id,
    });

    res.status(201).json({ success: true, data: comment });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error creating comment." });
  }
};

exports.getCommentsForBlog = async (req, res) => {
  try {
    const BlogId = req.params.id;
    const blogComments = await Comment.findAll({ where: { BlogId } });

    if (!blogComments || blogComments.length === 0) {
      return res
        .status(200)
        .json({ success: false, data: "Comments not found." });
    }

    res.status(200).json({ success: true, data: blogComments });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error fetching comments." });
  }
};
