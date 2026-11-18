var medidaModel = require("../models/medidaModel");

function buscarStatusVagas(req, res) {
  medidaModel.buscarStatusVagas(req.params.idEstacionamento)
    .then(r => res.status(200).json(r))
    .catch(e => res.status(500).json(e.sqlMessage));
}

module.exports = { buscarStatusVagas };