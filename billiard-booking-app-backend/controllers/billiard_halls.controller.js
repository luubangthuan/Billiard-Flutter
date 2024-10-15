const BilliardHall = require("../models/billiard_halls.model");

const billiardHallsController = {
  // Lấy thông tin billiard hall theo ID
  getBilliardHallByID: async (req, res) => {
    try {
      const billiardHall = await BilliardHall.findById(req.params.id);
      if (!billiardHall) {
        return res.status(404).json({ message: "Billiard hall not found" });
      }
      res.status(200).json({ data: billiardHall });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  // Lấy tất cả billiard halls
  getAllBilliardHalls: async (req, res) => {
    try {
      const billiardHalls = await BilliardHall.find();
      res.status(200).json({ data: billiardHalls });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lấy billiard halls theo rating từ 4 sao trở lên
  getHallsByHighRating: async (req, res) => {
    try {
      const highRatingHalls = await BilliardHall.find({ rating: { $gte: 4 } });
      res.status(200).json({ data: highRatingHalls });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lấy billiard halls có popular từ 60 trở lên
  getHallsByHighPopular: async (req, res) => {
    try {
      const highPopularHalls = await BilliardHall.find({ popular: { $gte: 60 } });
      res.status(200).json({ data: highPopularHalls });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Thêm mới billiard hall
  addBilliardHall: async (req, res) => {
    try {
      const {
        name,
        longitude,
        latitude,
        rating,
        address,
        price_per_hour,
        vibe_short_description,
        popular, // Lấy thêm trường popular
        type_halls, // Lấy thêm trường type_halls
      } = req.body;

      // Kiểm tra xem đã đủ thông tin cần thiết chưa
      if (
        !name ||
        !longitude ||
        !latitude ||
        !rating ||
        !address ||
        !price_per_hour ||
        !vibe_short_description ||
        !popular || // Kiểm tra trường popular
        !type_halls // Kiểm tra trường type_halls
      ) {
        return res.status(400).json({ message: "All fields are required" });
      }

      const newBilliardHall = new BilliardHall({
        name,
        longitude,
        latitude,
        rating,
        address,
        price_per_hour,
        vibe_short_description,
        popular, // Thêm giá trị popular
        type_halls, // Thêm giá trị type_halls
        createdDate: new Date(),
        updatedDate: new Date(),
      });

      const savedBilliardHall = await newBilliardHall.save();
      res.status(201).json({ data: savedBilliardHall });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  // Cập nhật thông tin billiard hall theo ID
  updateBilliardHallByID: async (req, res) => {
    try {
      const updatedData = { ...req.body, updatedDate: new Date() };

      const updatedBilliardHall = await BilliardHall.findByIdAndUpdate(
        req.params.id,
        { $set: updatedData },
        { new: true } // trả về document đã cập nhật
      );

      if (!updatedBilliardHall) {
        return res.status(404).json({ message: "Billiard hall not found" });
      }

      res.status(200).json({ message: "Updated successfully!" });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  // Xóa billiard hall theo ID
  deleteBilliardHallByID: async (req, res) => {
    try {
      const deletedBilliardHall = await BilliardHall.findByIdAndRemove(
        req.params.id
      );
      if (!deletedBilliardHall) {
        return res.status(404).json({ message: "Billiard hall not found" });
      }

      res.status(200).json({ message: "Deleted successfully!" });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },
};

module.exports = billiardHallsController;
