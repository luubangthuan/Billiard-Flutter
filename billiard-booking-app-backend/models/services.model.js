const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const serviceSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    required: true,
    enum: ["food", "drink", "others"], // Dịch vụ có thể là food, drink hoặc others
  },
  billiard_halls_id: [{
    type: Schema.Types.ObjectId, 
    ref: "billiard_halls", // Tham chiếu tới bảng billiard_halls
    required: true,
  }],
  price: {
    type: Number,
    required: true,
    min: 50000,
    max: 2000000,
  },
  created_at: {
    type: Date,
    default: Date.now,
  },
  updated_at: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("services", serviceSchema);
