const router = require("express").Router();
const blogController = require("../controllers/blog_controller");

router.post("/", blogController.createBlogPost);

router.get("/", blogController.getAllBlogPosts);

router.get("/:category", blogController.getBlogsByCategory);

router.put("/:id", blogController.updateBlogPost);

router.delete('/:id', blogController.deleteBlogPost);

module.exports = router;
