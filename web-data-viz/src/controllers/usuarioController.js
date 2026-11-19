var usuarioModel = require("../models/usuarioModel");

function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está indefinida!");
    } else {
        usuarioModel.autenticar(email, senha)
            .then(function (resultadoAutenticar) {
                if (resultadoAutenticar.length == 1) {
                    res.json({
                        id: resultadoAutenticar[0].id_funcionario_usuario,
                        nome: resultadoAutenticar[0].nome,
                        email: resultadoAutenticar[0].email,
                        codigoValidacao: resultadoAutenticar[0].UsuarioId
                    });
                } else if (resultadoAutenticar.length == 0) {
                    res.status(403).send("Email e/ou senha inválido(s)");
                } else {
                    res.status(403).send("Mais de um usuário com o mesmo login e senha!");
                }
            })
            .catch(function (erro) {
                console.log(erro);
                console.log("\nHouve um erro ao realizar o login! Erro: ", erro.sqlMessage);
                res.status(500).json(erro.sqlMessage);
            });
    }
}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var cpf = req.body.cpfServer;
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;
    var fk_cargo = req.body.id_cargoServer;
    var codigo_validacao = req.body.codigo_validacaoServer;

    if (nome == undefined) {
        res.status(400).send("Seu nome está undefined!");
    } else if (cpf == undefined) {
        res.status(400).send("Seu cpf está undefined!");
    } else if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está undefined!");
    } else if (fk_cargo == undefined) {
        res.status(400).send("Seu cargo está undefined");
    } else if (codigo_validacao == undefined) {
        res.status(400).send("Seu código de validação está undefined");
    } else {
        usuarioModel.buscarEmpresaPorCodigo(codigo_validacao)
            .then(function (resultadoEmpresa) {
                if (resultadoEmpresa.length == 0) {
                    res.status(400).send("Código de validação inválido!");
                    return;
                }

                var fk_empresa = resultadoEmpresa[0].id_empresa;

                return usuarioModel.cadastrar(nome, cpf, email, senha, fk_empresa, fk_cargo)
                    .then(function (resultado) {
                        res.json(resultado);
                    });
            })
            .catch(function (erro) {
                console.log(erro);
                console.log("\nHouve um erro ao realizar o cadastro! Erro: ", erro.sqlMessage);
                res.status(500).json(erro.sqlMessage);
            });
    }
}

module.exports = {
    autenticar,
    cadastrar
}