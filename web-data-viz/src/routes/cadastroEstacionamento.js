const express = require("express");
const router = express.Router();
const cadastroEstacionamentoController = require("../controllers/cadastroEstacionamentoController");

router.post("/", cadastroEstacionamentoController.cadastrar);

module.exports = router;