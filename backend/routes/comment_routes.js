const router = require("express").Router();
const commentController = require("../controllers/comment_controller");

router.post("/", commentController.createComment);

router.get("/:id", commentController.getCommentsForBlog);

module.exports = router;
