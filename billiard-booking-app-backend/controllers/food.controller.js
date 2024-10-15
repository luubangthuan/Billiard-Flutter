const Food = require("../models/food.model");

const FoodController = {
  getFoodByID: async (req, res) => {
    try {
      const foodRes = await Food.findById(req.params.id);
      res.status(200).json(foodRes);
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  getAllFoods: async (req, res) => {
    try {
      const foods = await Food.find();
      res.status(200).json({ data: foods });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  filterFoods: async (req, res) => {
    try {
      const { foodtype } = req.query;
      var filter = {};
      if (foodtype) {
        filter = {
          ...filter,
          foodType: { $regex: foodtype, $options: "i" },
        };
      }

      const dataRes = await Food.find(filter).exec();

      res.status(200).json({data: dataRes});
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  addFood: async (req, res) => {
    try {
      console.log("---req body---", req.body);
      const newFood = new Food(req.body);
      const savedFood = await newFood.save();
      console.log("---saving---", savedFood);
      return res.status(200).json({ data: savedFood });
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  updateFoodByID: async (req, res) => {
    try {
      const food = await Food.findById(req.params.id);
      console.log(food);
      await food.updateOne({ $set: req.body });

      res.status(200).json("Updated successfully!");
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },

  deleteFoodByID: async (req, res) => {
    try {
      await Food.findByIdAndDelete(req.params.id);
      res.status(200).json("Deleted successfully!");
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
  },
};

module.exports = FoodController;
