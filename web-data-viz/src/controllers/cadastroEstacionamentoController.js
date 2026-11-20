const cadastroEstacionamento = require("../models/cadastroEstacionamentoModel");

const cepRegex = /^\d{5}-?\d{3}$/;

exports.cadastrar = async (req, res) => {
  try {
    const { nome, codigoValidacao, rua, bairro, cep } = req.body;

    if (!nome || !codigoValidacao || !rua || !bairro || !cep) {
      return res.status(400).json({ erro: "Preencha todos os campos." });
    }

    if (!cepRegex.test(cep)) {
      return res.status(400).json({ erro: "CEP inválido." });
    }

    const empresa = await cadastroEstacionamento.buscarEmpresaPorCodigo(codigoValidacao.trim());
    if (!empresa) {
      return res.status(404).json({ erro: "Código de validação não encontrado." });
    }

    const novoCadastro = await cadastroEstacionamento.cadastrar({
      nome: nome.trim(),
      rua: rua.trim(),
      bairro: bairro.trim(),
      cep: cep.replace(/^(\d{5})(\d{3})$/, "$1-$2"),
      fkEmpresa: empresa.id_empresa,
    });

    return res.status(201).json(novoCadastro);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ erro: "Erro ao cadastrar estacionamento." });
  }
};
