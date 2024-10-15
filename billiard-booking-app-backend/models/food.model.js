const mongoose = require("mongoose");

const foodSchema = new mongoose.Schema({
  name: {
    type: String,
    default: Date.now().toString(),
  },
  foodType: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true,
  },
});

module.exports = mongoose.model("foods", foodSchema);
