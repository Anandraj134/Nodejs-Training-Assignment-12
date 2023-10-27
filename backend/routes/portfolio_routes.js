const router = require("express").Router();
const portfolioController = require("../controllers/portfolio_controller");

router.post("/", portfolioController.addPortfolio);

router.get("/", portfolioController.getAllPortfolios);

router.get("/:id", portfolioController.getUsersPortfolio);

router.put("/:id", portfolioController.editPortfolio);

router.delete("/:id", portfolioController.deletePortfolio);

module.exports = router;
