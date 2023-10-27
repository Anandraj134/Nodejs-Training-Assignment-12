const BlogPost = require("../models/blog_model");

exports.createBlogPost = async (req, res) => {
  try {
    const { title, content, imageUrl, category } = req.body;

    const blogPost = await BlogPost.create({
      title,
      content,
      UserId: req.user.id,
      imageUrl: imageUrl,
      category: category,
    });

    res.status(200).json({ success: true, data: blogPost });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error creating blog post." });
  }
};

exports.getAllBlogPosts = async (req, res) => {
  try {
    const blogPosts = await BlogPost.findAll();
    res.status(200).json({ success: true, data: blogPosts });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ success: false, data: "Error fetching blog posts." });
  }
};

exports.updateBlogPost = async (req, res) => {
  try {
    const { title, content, imageUrl, category } = req.body;
    const postId = req.params.id;

    const blogPost = await BlogPost.findByPk(postId);

    if (!blogPost) {
      return res
        .status(404)
        .json({ success: false, data: "Blog post not found" });
    }

    blogPost.title = title;
    blogPost.content = content;
    blogPost.imageUrl = imageUrl;
    blogPost.category = category;
    await blogPost.save();

    res.status(200).json({ success: true, data: blogPost });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error updating blog post" });
  }
};

exports.deleteBlogPost = async (req, res) => {
  try {
    const postId = req.params.id;

    const blogPost = await BlogPost.findByPk(postId);

    if (!blogPost) {
      return res
        .status(404)
        .json({ success: false, data: "Blog post not found" });
    }

    await blogPost.destroy();

    res
      .status(200)
      .json({ success: true, data: "Blog deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error deleting blog post" });
  }
};

exports.getBlogsByCategory = async (req, res) => {
  try {
    const category = req.params.category;
    const blogPosts = await BlogPost.findAll({ where: { category } });
    res.status(200).json({ success: true, data: blogPosts });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ success: false, data: "Error fetching blog posts." });
  }
};
