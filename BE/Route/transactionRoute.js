const express = require("express");
const router = express.Router();
const middleware = require("../Middleware/TokenAuth");
const transactionController = require("../Controller/transactionController");

router.post("/insert-transaction", middleware, transactionController.insert);
router.get("/view-all-tr", middleware, transactionController.viewAllTrans);
router.get("/view-month-tr", middleware, transactionController.viewMonth);


module.exports = router;