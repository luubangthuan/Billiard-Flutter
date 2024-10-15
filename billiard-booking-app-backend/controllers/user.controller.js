const User = require("../models/user.model");
const UserServices = require("../services/user.service");

const userController = {
  // ADD USER
  addUser: async (req, res) => {
    try {
      console.log("---req body---", req.body);
      const { phone } = req.body;
      const duplicate = await UserServices.getUserByPhone(phone);

      if (duplicate) {
        return res.status(409).json({ message: "Already Registered" });
      }

      const newUser = new User(req.body);
      const savedUser = await newUser.save();
      return res.status(200).json({ data: savedUser });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  getAllUsers: async (req, res) => {
    try {
      const users = await User.find();
      res.status(200).json({ data: users });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  getUserByID: async (req, res) => {
    try {
      const userRes = await User.findById(req.params.id);
      res.status(200).json({ data: userRes} );
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  updateUserByID: async (req, res) => {
    try {
      const user = await User.findById(req.params.id);
      await user.updateOne({ $set: req.body });
      res.status(200).json("Updated successfully!");
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  deleteUserByID: async (req, res) => {
    try {
      await User.findByIdAndDelete(req.params.id);
      res.status(200).json("Deleted successfully!");
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },
};

module.exports = userController;