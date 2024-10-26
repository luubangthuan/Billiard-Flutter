const mongoose = require("mongoose");

const billiardHallSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  location: {
    type: {
      type: String,
      enum: ["Point"],
      required: true,
    },
    coordinates: {
      type: [Number],
      required: true,
    },
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
    type: Number,
    required: true,
    min: 1,
    max: 100,
  },
  type_halls: {
    type: String,
    required: true,
    enum: [
      "pool",
      "3c",
      "custom",
      "snooker",
      "English Billiards",
      "Carom",
      "Russian Pyramid",
    ],
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

// Create a 2dsphere index to support geospatial queries
billiardHallSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("billiard_halls", billiardHallSchema);
