const express = require("express");
const router = express.Router();
const middleware = require("../Middleware/TokenAuth");
const authController = require("../Controller/authController");

router.post("/register", authController.register);
router.post("/login", authController.login);
router.post("/logout", middleware, authController.logout);
// router.get("/profile", authController.profile);


module.exports = router;