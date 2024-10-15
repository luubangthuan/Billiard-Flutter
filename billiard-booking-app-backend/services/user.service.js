const UserModel = require("../models/user.model");
const jwt = require("jsonwebtoken");

class UserServices {
  static async getUserByPhone(phone) {
    try {
      return await UserModel.findOne({ phone });
    } catch (err) {
      console.log(err);
    }
  }

  static async checkUser(phone) {
    try {
      return await UserModel.findOne({ phone });
    } catch (error) {
      throw error;
    }
  }

  static async createNewTempClient(fullname, phone) {
    try {
      const userData = {
        fullname: fullname,
        phone: phone,
      };
      const newUser = new UserModel(userData);
      const savedUser = await newUser.save();
      return savedUser;
    } catch (error) {
      throw error;
    }
  }

  static async generateAccessToken(tokenData, JWTSecret_Key, JWT_EXPIRE) {
    return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
  }
}

module.exports = UserServices;
