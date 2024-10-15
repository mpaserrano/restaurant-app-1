// ℹ️ Gets access to environment variables/settings
// https://www.npmjs.com/package/dotenv
require("dotenv").config();

// ℹ️ Connects to the database
require("./db");

// Handles http requests (express is node js framework)
// https://www.npmjs.com/package/express
const express = require("express");
const cors = require('cors');
const app = express();

app.use(cors({
    origin: '*'
}));


// ℹ️ This function is getting exported from the config folder. It runs most pieces of middleware
require("./config")(app);

// 👇 Start handling routes here
const indexRoutes = require("./routes/index.routes");
app.use("/api/api", indexRoutes);

const authRoutes = require("./routes/auth.routes");
app.use("/api/auth", authRoutes);

const itemsRoutes = require("./routes/items.routes");
app.use("/api/items", itemsRoutes);

const UsersRoutes = require("./routes/users.routes");
app.use("/api/users", UsersRoutes);


const CouponRoutes = require("./routes/coupons.routes");
app.use("/api/coupons", CouponRoutes);

const CampaignRoutes = require("./routes/campaigns.routes");
app.use("/api/campaign", CampaignRoutes);

const DietaryRoutes = require("./routes/dietary.routes");
app.use("/api/dietary", DietaryRoutes);

const OrdersRoutes = require("./routes/orders.routes");
app.use("/api/orders", OrdersRoutes);

// ❗ To handle errors. Routes that don't exist or errors that you handle in specific routes
require("./error-handling")(app);

module.exports = app;
