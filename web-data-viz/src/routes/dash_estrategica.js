var express = require("express");
var router = express.Router();

var dashboardEstrategicaController = require("../controllers/dashboard_estrategicaController");

router.get("/ociosidade-media/:idEstacionamento", function (req, res) {
    dashboardEstrategicaController.buscarOciosidadeMedia(req, res);
});

router.get("/ociosidade-horario/:idEstacionamento", function (req, res) {
    dashboardEstrategicaController.buscarOciosidadePorHorario(req, res);
});

module.exports = router;