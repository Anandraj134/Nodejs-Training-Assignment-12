const Portfolio = require("../models/portfolio_model");

exports.getAllPortfolios = async (req, res) => {
  try {
    const portfolios = await Portfolio.findAll();
    res.status(200).json({ success: true, data: portfolios });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error fetching portfolios." });
  }
};

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

    res.status(201).json({ success: true, data: portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error adding portfolio." });
  }
};

exports.editPortfolio = async (req, res) => {
  try {
    const { title, description, technologiesUsed, githubLink } = req.body;
    const portfolioId = req.params.id;

    const portfolio = await Portfolio.findByPk(portfolioId);

    if (!portfolio) {
      return res.status(404).json({ success: false, data: "Portfolio not found" });
    }

    portfolio.title = title;
    portfolio.description = description;
    portfolio.technologiesUsed = technologiesUsed;
    portfolio.githubLink = githubLink;
    await portfolio.save();

    res.status(200).json({ success: true, data: portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error editing portfolio." });
  }
};

exports.deletePortfolio = async (req, res) => {
  try {
    const portfolioId = req.params.id;
    const portfolio = await Portfolio.findByPk(portfolioId);

    if (!portfolio) {
      return res.status(404).json({ success: false, data: "Portfolio not found" });
    }

    await portfolio.destroy();

    res.status(200).json({ success: true, data: "Portfolio deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error deleting portfolio." });
  }
};

exports.getUsersPortfolio = async (req, res) => {
  try {
    const portfolios = await Portfolio.findAll({
      where: { UserId: req.params.id },
    });

    res.status(200).json({ success: true, data: portfolios });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Error fetching user's portfolio." });
  }
};
