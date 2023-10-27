const Portfolio = require("../models/portfolio_model");

// Fetch all portfolios
exports.getAllPortfolios = async (req, res) => {
  try {
    const portfolios = await Portfolio.findAll();
    res.json({ success: true, data: portfolios });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ success: false, data: "Error fetching portfolios." });
  }
};

// Add a portfolio
exports.addPortfolio = async (req, res) => {
  try {
    const { title, description, technologiesUsed, githubLink } = req.body;

    const portfolio = await Portfolio.create({
      title,
      description,
      technologiesUsed,
      githubLink,
      UserId: req.user.id,
    });

    res.json({ success: true, data: portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error adding portfolio." });
  }
};

// Edit a portfolio by ID
exports.editPortfolio = async (req, res) => {
  try {
    const { title, description, technologiesUsed, githubLink } = req.body;
    const portfolioId = req.params.id;

    const portfolio = await Portfolio.findByPk(portfolioId);

    if (!portfolio) {
      return res
        .status(404)
        .json({ success: false, data: "Portfolio not found" });
    }

    portfolio.title = title;
    portfolio.description = description;
    portfolio.technologiesUsed = technologiesUsed;
    portfolio.githubLink = githubLink;
    await portfolio.save();
    res.json({ success: true, data: portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error editing portfolio." });
  }
};

// Delete a portfolio by ID
exports.deletePortfolio = async (req, res) => {
  try {
    const portfolioId = req.params.id;
    const portfolio = await Portfolio.findByPk(portfolioId);

    if (!portfolio) {
      return res
        .status(404)
        .json({ success: false, data: "Portfolio not found" });
    }

    await portfolio.destroy();
    res.json({ success: true, data: "Portfolio deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error deleting portfolio." });
  }
};

exports.getUsersPortfolio = async (req, res) => {
  try {
    const portfolio = await Portfolio.findAll({
      where: { UserId: req.params.id },
    });
    res.json({ success: true, data: portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error deleting portfolio." });
  }
};
