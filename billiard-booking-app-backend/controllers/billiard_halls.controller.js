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
      const highPopularHalls = await BilliardHall.find({
        popular: { $gte: 60 },
      });
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

      // Construct the GeoJSON point for location
      const location = {
        type: "Point",
        coordinates: [parseFloat(longitude), parseFloat(latitude)],
      };

      const newBilliardHall = new BilliardHall({
        name,
        location, // Assign the location correctly
        rating,
        address,
        price_per_hour,
        vibe_short_description,
        popular, // Thêm giá trị popular
        type_halls, // Thêm giá trị type_halls
        created_at: new Date(),
        updated_at: new Date(),
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

  // Tìm kiếm billiard halls theo tên hoặc địa chỉ
  searchBilliardHalls: async (req, res) => {
    try {
      const { name, city, district, street } = req.query;

      // Nếu không có bất kỳ query parameter nào, trả về lỗi
      if (!name && !city && !district && !street) {
        return res
          .status(400)
          .json({ message: "At least one query parameter is required" });
      }

      // Tạo điều kiện tìm kiếm dựa trên các query parameter được truyền vào
      const searchQuery = {};

      if (name) {
        searchQuery.name = { $regex: name, $options: "i" };
      }

      if (city) {
        searchQuery["address.city"] = { $regex: city, $options: "i" };
      }

      if (district) {
        searchQuery["address.district"] = { $regex: district, $options: "i" };
      }

      if (street) {
        searchQuery["address.street"] = { $regex: street, $options: "i" };
      }

      const results = await BilliardHall.find(searchQuery);

      // Nếu không tìm thấy kết quả nào
      if (results.length === 0) {
        return res.status(404).json({ message: "No billiard halls found" });
      }

      // Trả về danh sách kết quả tìm kiếm
      res.status(200).json({ data: results });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lọc billiard halls theo loại (type_halls)
  filterBilliardHallsByType: async (req, res) => {
    try {
      const { type } = req.query;

      if (!type) {
        return res.status(400).json({ message: "Type parameter is required" });
      }

      // Lọc theo type_halls
      const filteredHalls = await BilliardHall.find({ type_halls: type });

      if (filteredHalls.length === 0) {
        return res
          .status(404)
          .json({ message: "No billiard halls found for the specified type" });
      }

      res.status(200).json({ data: filteredHalls });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Get nearby billiard halls based on latitude, longitude, and maxDistance
  getNearbyBilliardHalls: async (req, res) => {
    try {
      const { latitude, longitude, maxDistance } = req.query;

      if (!latitude || !longitude) {
        return res
          .status(400)
          .json({ message: "Latitude and longitude are required" });
      }

      const distance = maxDistance ? parseInt(maxDistance, 10) : 5000; // Default max distance is 5000 meters

      // Find nearby billiard halls using GeoJSON coordinates
      const nearbyHalls = await BilliardHall.find({
        location: {
          $near: {
            $geometry: {
              type: "Point",
              coordinates: [parseFloat(longitude), parseFloat(latitude)],
            },
            $maxDistance: distance,
          },
        },
      }).select("-services");;

      if (nearbyHalls.length === 0) {
        return res
          .status(404)
          .json({ message: "No nearby billiard halls found" });
      }

      res.status(200).json({ data: nearbyHalls });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },
};

module.exports = billiardHallsController;
