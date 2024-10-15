const UserServices = require("../services/user.service");

const authController = {
  // CHECK USER
  checkLogin: async (req, res, next) => {
    try {
      const { phone, password } = req.body;

      if (!phone || !password) {
        throw new Error("Parameter are not correct");
      }

      let user = await UserServices.checkUser(phone);
      if (!user) {
        throw new Error("User does not exist");
      }

      const isPasswordCorrect = await user.comparePassword(password);
      if (isPasswordCorrect === false) {a
        throw new Error(`Username or Password does not match`);
      }

      // Creating Token
      let tokenData;
      tokenData = {
        _id: user._id, 
        fullname: user.fullname, 
        phone: user.phone, 
        password: user.password, 
        role: user.role
        };
      const token = await UserServices.generateAccessToken(tokenData,process.env.SECRET_TOKEN_CODE, "15m")

      res.status(200).json({success: "Login Successfully!", token: token });

      // console.log(req.body, token);
    } catch (error) {
      res.status(500).json({ message: error.message });
      console.log(req.body);
    }
  },
};

module.exports = authController;
