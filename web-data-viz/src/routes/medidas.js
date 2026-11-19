var express = require("express");
var router = express.Router();

var medidaController = require("../controllers/medidaController");

router.get("/vagas/:idEstacionamento", function (req, res) {
  medidaController.buscarStatusVagas(req, res);
});

module.exports = router;