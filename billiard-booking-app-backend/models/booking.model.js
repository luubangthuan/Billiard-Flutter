const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const bookingSchema = new mongoose.Schema({
  personInfo: {
    name: {
      type: String,
      required: true,
    },
    phone: {
      type: String,
      required: true,
    },
  },
  bookingInfo: {
    tableType: {
      type: String,
      required: true,
    },
    bookingTime: {
      type: Date,
      required: true,
    },
    amountTimeBooking: {
      type: Number,
      required: true,
    },
    extras: [
      {
        name: { type: String, required: true },
        price: { type: Number, required: true },
      },
    ],
  },
  hallInfo: {
    hall_id: {
      type: Schema.Types.ObjectId,
      ref: "billiard_halls",
      required: true,
    },
  },
  totalPayment: {
    type: Number,
    required: true,
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

module.exports = mongoose.model("bookings", bookingSchema);
