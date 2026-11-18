var express = require("express");
var router = express.Router();

var kpisController = require("../controllers/kpisController");

//Recebendo os dados do html e direcionando para a função cadastrar de usuarioController.js
router.get("/obterKpi", function (req, res) {
    kpisController.obterKpi(req, res);
})

module.exports = router;