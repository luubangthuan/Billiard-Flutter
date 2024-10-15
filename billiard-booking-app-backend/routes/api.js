const router = require("express").Router();
const authController = require("../controllers/auth.controller");
const FoodController = require("../controllers/food.controller");
const tableController = require("../controllers/table.controller");
const userController = require("../controllers/user.controller");
const bookingController = require("../controllers/booking.controller");
const billiardHallsController = require("../controllers/billiard_halls.controller");
const servicesController = require("../controllers/services.controller");

const initAPIRoute = (app) => {
  /**
   * @description AUTH ROUTES
   */
  router.post("/login", authController.checkLogin);

  /**
   * @description USER ROUTES
   */
  router.post("/users", userController.addUser);
  router.get("/users", userController.getAllUsers);
  router.get("/users/:id", userController.getUserByID);
  router.put("/users/:id", userController.updateUserByID);
  router.delete("/users/:id", userController.deleteUserByID);

  /**
   * @description FOOD ROUTES
   */
  router.get("/foods", FoodController.getAllFoods);
  router.get("/foods/filter", FoodController.filterFoods);
  router.get("/foods/:id", FoodController.getFoodByID);
  router.post("/foods", FoodController.addFood);
  router.put("/foods/:id", FoodController.updateFoodByID);
  router.delete("/foods/:id", FoodController.deleteFoodByID);

  /**
   * @description FOOD ROUTES
   */
  router.get("/bookings", bookingController.getAllBookings);
  router.get("/bookings/:id", bookingController.getBookingByID);
  router.post("/bookings", bookingController.addBooking);
  router.put("/bookings/:id", bookingController.updateBookingByID);
  router.delete("/bookings/:id", bookingController.deleteBookingByID);

  /**
   * @description BILLIARD HALLS ROUTES
   */
  router.get("/billiard_halls", billiardHallsController.getAllBilliardHalls);
  router.get(
    "/billiard_halls/high_rating",
    billiardHallsController.getHallsByHighRating
  );
  router.get(
    "/billiard_halls/high_popular",
    billiardHallsController.getHallsByHighPopular
  );
  router.get(
    "/billiard_halls/:id",
    billiardHallsController.getBilliardHallByID
  );
  router.post("/billiard_halls", billiardHallsController.addBilliardHall);
  router.put(
    "/billiard_halls/:id",
    billiardHallsController.updateBilliardHallByID
  );
  router.delete(
    "/billiard_halls/:id",
    billiardHallsController.deleteBilliardHallByID
  );


  /**
   * @description SERVICES ROUTES
   */
  router.get("/services", servicesController.getAllServices);
  router.get("/services/filter", servicesController.filterServices);
  router.get("/services/:id", servicesController.getServiceByID);
  router.post("/services", servicesController.addService);
  router.put("/services/:id", servicesController.updateServiceByID);
  router.delete("/services/:id", servicesController.deleteServiceByID);
  router.get(
    "/services/hall/:billiard_halls_id",
    servicesController.filterServicesByBilliardHallId
  );

   /**
   * @description TABLES ROUTES
   */
   router.post("/tables", tableController.createTable); // Tạo mới bàn
   router.get("/tables", tableController.getAllTables); // Lấy tất cả các bàn
   router.get("/tables/:id", tableController.getTableById); // Lấy bàn theo ID
   router.put("/tables/:id", tableController.updateTable); // Cập nhật bàn theo ID
   router.delete("/tables/:id", tableController.deleteTable); // Xóa bàn theo ID
   router.get("/tables/hall/:hall_id", tableController.getTablesByHallId);



  return app.use("/api/v1", router);
};

module.exports = initAPIRoute;
