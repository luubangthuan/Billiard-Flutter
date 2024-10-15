const Service = require("../models/services.model");

const servicesController = {
  // Lấy tất cả dịch vụ
  getAllServices: async (req, res) => {
    try {
      const services = await Service.find().populate('billiard_halls_id');
      res.status(200).json({ data: services });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lọc dịch vụ theo loại (food, drink, others)
  filterServices: async (req, res) => {
    try {
      const { type } = req.query; // Lọc theo query type
      const services = await Service.find({ type }).populate('billiard_halls_id');
      res.status(200).json({ data: services });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lấy dịch vụ theo ID
  getServiceByID: async (req, res) => {
    try {
      const service = await Service.findById(req.params.id).populate('billiard_halls_id');
      if (!service) {
        return res.status(404).json({ message: "Service not found" });
      }
      res.status(200).json({ data: service });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Thêm mới dịch vụ
  addService: async (req, res) => {
    try {
      const { name, type, billiard_halls_id, price } = req.body;

      if (!name || !type || !billiard_halls_id || !price) {
        return res.status(400).json({ message: "All fields are required" });
      }

      const newService = new Service({
        name,
        type,
        billiard_halls_id,
        price,
      });

      const savedService = await newService.save();
      res.status(201).json({ data: savedService });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Cập nhật dịch vụ theo ID
  updateServiceByID: async (req, res) => {
    try {
      const updatedData = { ...req.body, updated_at: new Date() };

      const updatedService = await Service.findByIdAndUpdate(
        req.params.id,
        { $set: updatedData },
        { new: true } // Trả về document đã cập nhật
      );

      if (!updatedService) {
        return res.status(404).json({ message: "Service not found" });
      }

      res.status(200).json({ message: "Updated successfully!" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Xóa dịch vụ theo ID
  deleteServiceByID: async (req, res) => {
    try {
      const deletedService = await Service.findByIdAndRemove(req.params.id);
      if (!deletedService) {
        return res.status(404).json({ message: "Service not found" });
      }

      res.status(200).json({ message: "Deleted successfully!" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Lọc dịch vụ theo billiard_halls_id
  filterServicesByBilliardHallId: async (req, res) => {
    try {
      const { billiard_halls_id } = req.params;

      const services = await Service.find({ billiard_halls_id: billiard_halls_id }).populate('billiard_halls_id');

      if (!services || services.length === 0) {
        return res.status(404).json({ message: "No services found for this billiard hall" });
      }

      res.status(200).json({ data: services });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  searchBilliardHalls: async (req, res) => {
    try {
      const { name, address } = req.query;

      // Build the search query dynamically based on provided search parameters
      const searchQuery = {};

      if (name) {
        searchQuery.name = { $regex: name, $options: "i" }; // Case-insensitive search for name
      }

      if (address) {
        searchQuery["address.street"] = { $regex: address, $options: "i" }; // Case-insensitive search for address
      }

      const billiardHalls = await BilliardHall.find(searchQuery);

      if (billiardHalls.length === 0) {
        return res.status(404).json({ message: "No billiard halls found" });
      }

      res.status(200).json({ data: billiardHalls });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },
};

module.exports = servicesController;
