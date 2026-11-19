var cadastroEmpresaModel = require("../models/cadastroEmpresaModel");

function cadastrar(req, res) {
    var nomeFantasia = req.body.nomeFantasiaServer;
    var cnpj = req.body.cnpjServer;
    var codigoValidacao = req.body.codigoValidacaoServer;
    var razaoSocial = req.body.razaoSocialServer;

    if (!nomeFantasia) {
        return res.status(400).send("Nome fantasia está undefined!");
    }
    if (!cnpj || cnpj.length != 14) {
        return res.status(400).send("CNPJ inválido!");
    }
    if (!codigoValidacao || codigoValidacao.length != 5) {
        return res.status(400).send("Código de validação inválido!");
    }
    if (!razaoSocial) {
        return res.status(400).send("Razão social está undefined!");
    }

    // Evita CNPJ duplicado
    cadastroEmpresaModel.buscarPorCnpj(cnpj)
        .then(function (resultado) {
            if (resultado.length > 0) {
                return res.status(409).send("Já existe uma empresa com esse CNPJ.");
            }

            cadastroEmpresaModel.cadastrar(nomeFantasia, cnpj, codigoValidacao, razaoSocial)
                .then(function (resultadoInsert) {
                    res.status(201).json(resultadoInsert);
                })
                .catch(function (erro) {
                    console.log("Erro ao cadastrar empresa: ", erro.sqlMessage);
                    res.status(500).json(erro.sqlMessage);
                });
        })
        .catch(function (erro) {
            console.log("Erro ao verificar CNPJ: ", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    cadastrar
};