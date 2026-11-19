var database = require("../database/config")

function obterKpi(senha) {
    console.log("ACESSEI O OBTERKPI MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ", email, senha)
    
    var instrucaoSql = `
        SELECT
e.id_estacionamento,
e.nome AS estacionamento,
 COUNT(v.id_vaga) AS total_vagas,
    SUM(CASE
        WHEN sm.leitura_sensor = 1 THEN 1
        ELSE 0
    END) AS vagas_ocupadas,
    SUM(CASE
        WHEN sm.leitura_sensor = 0 THEN 1
        ELSE 0
    END) AS vagas_livres,
    ROUND(
        SUM(CASE
            WHEN sm.leitura_sensor = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(v.id_vaga), 2
    ) AS percentual_ocupacao
FROM Estacionamento e
INNER JOIN Vaga v
    ON v.fk_estacionamento = e.id_estacionamento
LEFT JOIN Sensor_medida sm
    ON sm.fk_vaga = v.id_vaga
    AND sm.dt_hora_leitura = (
        SELECT MAX(sm2.dt_hora_leitura)
        FROM Sensor_medida sm2
        WHERE sm2.fk_vaga = v.id_vaga)
GROUP BY
    e.id_estacionamento,
    e.nome;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    obterKpi
};