const mongoose = require("mongoose");
const UserModel = require("./user.model");
const Schema = mongoose.Schema;

const bookingSchema = new mongoose.Schema({
  userID: {
    type: Schema.Types.ObjectId,
    ref: UserModel.modelName,
  },
  arrivalTime: {
    type: Date,
    required: true,
  },
  createdDate: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("bookings", bookingSchema);
