var database = require("../database/config");

function cadastrar(nomeFantasia, cnpj, codigoValidacao, razaoSocial) {
    var instrucaoSql = `
        INSERT INTO empresa (nome_fantasia, cnpj, dt_cadastro, codigo_validacao, razao_social)
        VALUES ('${nomeFantasia}', '${cnpj}', CURDATE(), '${codigoValidacao}', '${razaoSocial}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
    var instrucaoSql = `SELECT id_empresa FROM empresa WHERE cnpj = '${cnpj}';`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    cadastrar,
    buscarPorCnpj
};