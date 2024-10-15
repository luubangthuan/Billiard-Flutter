const Table = require("../models/table.model");
const mongoose = require('mongoose');

// Tạo mới một bàn
exports.createTable = async (req, res) => {
  try {
    const table = new Table(req.body);
    await table.save();
    res.status(201).json(table);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Lấy tất cả các bàn
exports.getAllTables = async (req, res) => {
  try {
    const tables = await Table.find().populate("hall_id");
    res.json(tables);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Lấy bàn theo ID
exports.getTableById = async (req, res) => {
  try {
    const table = await Table.findById(req.params.id).populate("hall_id");
    if (!table) return res.status(404).json({ message: "Table not found" });
    res.json(table);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Cập nhật bàn
exports.updateTable = async (req, res) => {
  try {
    const table = await Table.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!table) return res.status(404).json({ message: "Table not found" });
    res.json(table);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Xóa bàn
exports.deleteTable = async (req, res) => {
  try {
    const table = await Table.findByIdAndDelete(req.params.id);
    if (!table) return res.status(404).json({ message: "Table not found" });
    res.json({ message: "Table deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Lấy các bàn theo hall_id (sử dụng $in để kiểm tra array của hall_id)
exports.getTablesByHallId = async (req, res) => {
  try {
    const hallId = new mongoose.Types.ObjectId(req.params.hall_id.trim()); // Convert hall_id to ObjectId using 'new'
    
    // Sử dụng $in để kiểm tra hall_id có trong mảng hall_id hay không
    const tables = await Table.find({ hall_id: { $in: [hallId] } });

    if (tables.length === 0) {
      return res.status(404).json({ message: "No tables found for this hall." });
    }
    res.status(200).json(tables);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
