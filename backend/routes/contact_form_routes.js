const router = require("express").Router();
const contactUsController = require("../controllers/contact_form_controller");

router.post("/", contactUsController.sendMail);

module.exports = router;
