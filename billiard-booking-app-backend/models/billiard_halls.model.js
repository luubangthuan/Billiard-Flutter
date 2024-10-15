const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const billiardHallSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  latitude: {
    type: Number,
    required: true,
  },
  rating: {
    type: Number,
    min: 0,
    max: 5,
    required: true,
  },
  address: {
    street: {
      type: String,
      required: true,
    },
    district: {
      type: String,
      required: true,
    },
    city: {
      type: String,
      required: true,
    },
  },
  price_per_hour: {
    type: Number,
    required: true,
  },
  vibe_short_description: {
    type: String,
    required: true,
  },
  popular: {
    type: Number, // Thêm trường popular
    required: true,
    min: 1,
    max: 100,
  },
  type_halls: {
    type: String, // Thêm trường type_halls
    required: true,
    enum: ["pool", "3c", "custom", "snooker", "English Billiards", "Carom", "Russian Pyramid"]
  },
  createdDate: {
    type: Date,
    default: Date.now,
  },
  updatedDate: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("billiard_halls", billiardHallSchema);
