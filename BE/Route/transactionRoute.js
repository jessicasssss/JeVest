const express = require("express");
const router = express.Router();
const middleware = require("../Middleware/TokenAuth");
const transactionController = require("../Controller/transactionController");

router.post("/insert-transaction", middleware, transactionController.insert);
router.get("/view-all-tr", middleware, transactionController.viewAllTrans);
router.post("/view-month-tr", middleware, transactionController.viewMonth);
router.post("/pie-chart", middleware, transactionController.chart);

module.exports = router;