const express = require("express");
const router = express.Router();
const budgetController = require("../Controller/budgetController");
const middleware = require("../Middleware/TokenAuth");


router.post("/insert-budget", middleware, budgetController.insert);
router.get("/get-budget", middleware, budgetController.getBudget);
router.patch("/update-budget", middleware, budgetController.update);

module.exports = router;