const nodemailer = require("nodemailer");

exports.sendMail = async (req, res) => {
  const { title, description, senderName, receiverName, receiverEmail } =
    req.body;
  try {
    let transporter = nodemailer.createTransport({
      service: "gmail",
      secure: true,
      auth: {
        user: process.env.USER_EMAIL,
        pass: process.env.USER_PASSWORD,
      },
    });

    let mailOptions = {
      from: process.env.USER_EMAIL,
      to: receiverEmail,
      subject: title,
      html: `
    <!DOCTYPE html>
<html>
<head>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
    }
    .header {
        background-color: #2196F3;
        color: #fff;
        text-align: center;
        padding: 10px;
    }
    .icon {
        text-align: center;
        margin-top: 20px; /* Add top margin here */
    }
    .content {
        background-color: #fff;
        padding: 20px;
    }
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome to Blogfolio!</h1>
        </div>
        <div class="icon">
            <img src="https://firebasestorage.googleapis.com/v0/b/assignment-384aa.appspot.com/o/blogfolioLogo%2Fblogfolio_icon.png?alt=media&token=f30d8e0f-4413-4ad9-9a8f-9503292017cd&_gl=1*1wp4k6g*_ga*MTc0ODUwNzc0Mi4xNjk0NTg3MzUx*_ga_CW55HF8NVT*MTY5ODIxMDkwNi4zNS4xLjE2OTgyMTA5NjkuNjAuMC4w" alt="Blogfolio Icon" height=100 width=98>
        </div>
        <div class="content">
            <p>Hello ${receiverName},</p>
            <p>${senderName} has just sent you a message:</p>
            <h2>${title}</h2>
            <p>${description}</p>
        </div>
    </div>
</body>
</html>
    `,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log("Email sent successfully:", info.response);
    res.status(200).json({ success: true, data: "Email sent successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, data: "Something went wrong" });
  }
};
