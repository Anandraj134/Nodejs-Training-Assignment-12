const router = require("express").Router();
const userController = require("../controllers/user_controller");

router.get("/", userController.getAllUsers);

router.put("/", userController.updateUser);

module.exports = router;
