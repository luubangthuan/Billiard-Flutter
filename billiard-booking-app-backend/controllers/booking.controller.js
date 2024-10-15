const Booking = require("../models/booking.model");
const UserModel = require("../models/user.model");
const UserServices = require("../services/user.service");
const userController = require("./user.controller");

const bookingController = {
  getBookingByID: async (req, res) => {
    try {
      const bookingRes = await Booking.findById(req.params.id).populate({
        path: "userID",
        model: UserModel.modelName,
        select: "fullname phone role",
      });

      const formattedBooking = {
        _id: bookingRes._id,
        userInfor: {
          fullname: bookingRes.userID.fullname,
          phone: bookingRes.userID.phone,
          role: bookingRes.userID.role,
        },
        arrivalTime: bookingRes.arrivalTime,
        createdDate: bookingRes.createdDate,
      };

      res.status(200).json({ data: formattedBooking });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  getAllBookings: async (req, res) => {
    try {
      const bookings = await Booking.find().populate({
        path: "userID",
        model: UserModel.modelName,
        select: "fullname phone role",
      });

      const formattedBookings = bookings.map((booking) => {
        return {
          _id: booking._id,
          userInfor: {
            fullname: booking.userID.fullname,
            phone: booking.userID.phone,
            role: booking.userID.role,
          },
          arrivalTime: booking.arrivalTime,
          createdDate: booking.createdDate,
          __v: booking.__v,
        };
      });

      res.status(200).json({ data: formattedBookings });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  addBooking: async (req, res) => {
    try {
      const { phone, fullname, arrivalTime } = req.body;
      let newBooking, savedBooking;

      // Kiểm tra xem số điện thoại đã tồn tại trong hệ thống hay chưa
      const existingUser = await UserServices.getUserByPhone(phone);

      // Dữ liệu để lưu
      const savedData = { arrivalTime };

      if (existingUser) {
        // Nếu số điện thoại đã tồn tại, sử dụng _id của người dùng hiện có để tạo đơn đặt bàn
        savedData.userID = existingUser._id;
      } else {
        // Nếu số điện thoại chưa tồn tại, tạo một tài khoản mới dựa trên số điện thoại
        const newClient = await UserServices.createNewTempClient(
          fullname,
          phone
        );
        savedData.userID = newClient._id;
      }

      // Tạo đơn đặt bàn
      newBooking = new Booking(savedData);
      savedBooking = await newBooking.save();

      return res.status(200).json({ data: savedData });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  updateBookingByID: async (req, res) => {
    try {
      const booking = await Booking.findById(req.params.id);
      await booking.updateOne({ $set: req.body });

      res.status(200).json("Updated successfully!");
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  deleteBookingByID: async (req, res) => {
    try {
      await Booking.findByIdAndDelete(req.params.id);
      res.status(200).json("Deleted successfully!");
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },
};

module.exports = bookingController;
