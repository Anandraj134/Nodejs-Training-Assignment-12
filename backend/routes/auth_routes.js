const router = require("express").Router();
const authController = require("../controllers/auth_controller");

router.post("/", authController.signup);

router.get("/", authController.login);

module.exports = router;
