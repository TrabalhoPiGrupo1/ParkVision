var database = require("../database/config");

function buscarStatusVagas(idEstacionamento) {
  var instrucao = `
    SELECT v.id_vaga, v.bloco, v.numero,
           sm.leitura_sensor, sm.dt_hora_leitura
    FROM Vaga v
    JOIN Sensor_medida sm ON sm.fk_vaga = v.id_vaga
    WHERE v.fk_estacionamento = ${idEstacionamento}
      AND sm.id_sensor_medida = (
        SELECT MAX(id_sensor_medida)
        FROM Sensor_medida
        WHERE fk_vaga = v.id_vaga
      )
    ORDER BY v.bloco, v.numero;`;
  return database.executar(instrucao);
}

module.exports = { buscarStatusVagas };