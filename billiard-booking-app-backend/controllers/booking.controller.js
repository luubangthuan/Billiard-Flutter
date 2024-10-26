const Booking = require("../models/booking.model");

const bookingsController = {
  // Lấy tất cả các booking
  getAllBookings: async (req, res) => {
    try {
      const bookings = await Booking.find().populate("hallInfo.hall_id");
      res.status(200).json({ data: bookings });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lấy booking theo ID
  getBookingByID: async (req, res) => {
    try {
      const booking = await Booking.findById(req.params.id).populate(
        "hallInfo.hall_id"
      );
      if (!booking) {
        return res.status(404).json({ message: "Booking not found" });
      }
      res.status(200).json({ data: booking });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lấy booking theo số điện thoại
  getBookingByPhone: async (req, res) => {
    try {
      const { phone } = req.params;
  
      const bookings = await Booking.find({
        "personInfo.phone": phone,
      }).populate({
        path: 'hallInfo.hall_id',
        select: '-services'
      });;
  
      if (!bookings || bookings.length === 0) {
        return res
          .status(404)
          .json({ message: "No bookings found for this phone number" });
      }
  
      res.status(200).json({ data: bookings });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Thêm mới booking
  addBooking: async (req, res) => {
    try {
      const { personInfo, bookingInfo, hallInfo, totalPayment } = req.body;

      if (
        !personInfo ||
        !bookingInfo ||
        !hallInfo ||
        totalPayment === undefined
      ) {
        return res.status(400).json({ message: "All fields are required" });
      }

      const newBooking = new Booking({
        personInfo,
        bookingInfo,
        hallInfo,
        totalPayment,
      });

      const savedBooking = await newBooking.save();
      res.status(201).json({ data: savedBooking });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Cập nhật booking theo ID
  updateBookingByID: async (req, res) => {
    try {
      const updatedData = { ...req.body, updated_at: new Date() };

      const updatedBooking = await Booking.findByIdAndUpdate(
        req.params.id,
        { $set: updatedData },
        { new: true }
      );

      if (!updatedBooking) {
        return res.status(404).json({ message: "Booking not found" });
      }

      res
        .status(200)
        .json({ message: "Updated successfully!", data: updatedBooking });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Xóa booking theo ID
  deleteBookingByID: async (req, res) => {
    try {
      const deletedBooking = await Booking.findByIdAndRemove(req.params.id);
      if (!deletedBooking) {
        return res.status(404).json({ message: "Booking not found" });
      }

      res.status(200).json({ message: "Deleted successfully!" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lọc booking theo billiard_hall_id
  filterBookingsByBilliardHallId: async (req, res) => {
    try {
      const { hall_id } = req.params;

      const bookings = await Booking.find({
        "hallInfo.hall_id": hall_id,
      }).populate("hallInfo.hall_id");

      if (!bookings || bookings.length === 0) {
        return res
          .status(404)
          .json({ message: "No bookings found for this billiard hall" });
      }

      res.status(200).json({ data: bookings });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },
};

module.exports = bookingsController;
