var database = require("../database/config")

function autenticar(email, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ", email, senha)
    
    var instrucaoSql = `
        SELECT u.id_funcionario_usuario, u.nome, u.email, e.codigo_validacao as UsuarioId 
        FROM usuario AS u
        JOIN empresa AS e
        ON e.id_empresa = u.fk_empresa
        WHERE u.email = '${email}' AND u.senha = '${senha}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrar(nome, cpf, email, usuario, senha, fk_empresa, fk_cargo) {
    var instrucaoSql = `
        INSERT INTO usuario (nome, cpf, email, usuario, senha, fk_empresa, fk_cargo)
        VALUES ('${nome}', '${cpf}', '${email}', '${usuario}', '${senha}', ${fk_empresa}, ${fk_cargo});
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarEmpresaPorCodigo(codigo_validacao) {
    var instrucaoSql = `
        SELECT id_empresa
        FROM empresa
        WHERE codigo_validacao = '${codigo_validacao}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    autenticar,
    buscarEmpresaPorCodigo,
    cadastrar
};