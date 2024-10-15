// LIBARIES
const express = require("express");
const dotenv = require("dotenv");
const morgan = require("morgan");
const bodyparser = require("body-parser");
const cors = require("cors");

// MODULES
const connectDB = require("./configs/database");
const initAPIRoute = require("./routes/api");
const app = express();
const PORT = process.env.PORT || 8080;

// PORT
dotenv.config({ path: "config.env" });

// MONGODB CONNECTION
connectDB();

// USE MIDDLEWARE LIBARIES
app.use(morgan("combined")); // log requests in terminal
app.use(bodyparser.json()); // converts the request into an object which is called 'body.req'
app.use(bodyparser.urlencoded({ extended: true }));
app.use(cors()); // allow sharing of resources between websites

// LOAD ROUTES
initAPIRoute(app); // api routes

// SERVER RUNNING
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
