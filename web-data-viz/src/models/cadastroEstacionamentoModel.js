const db = require("../config/database");

async function buscarEmpresaPorCodigo(codigoValidacao) {
  const [linhas] = await db.execute(
    "SELECT id_empresa FROM Empresa WHERE codigo_validacao = ?",
    [codigoValidacao]
  );
  return linhas[0] || null;
}

async function cadastrar({ nome, rua, bairro, cep, fkEmpresa }) {
  const conexao = await db.getConnection();

  try {
    // transação: ou salva nas duas tabelas, ou não salva em nenhuma
    await conexao.beginTransaction();

    // 1º: insere o endereço
    const [endereco] = await conexao.execute(
      "INSERT INTO endereco (logradouro, bairro, CEP) VALUES (?, ?, ?)",
      [rua, bairro, cep]
    );

    // 2º: insere o estacionamento usando o id do endereço recém-criado
    const [estacionamento] = await conexao.execute(
      `INSERT INTO Estacionamento
         (nome, status_estacionamento, dt_cadastro, fk_endereco, fk_empresa)
       VALUES (?, 'ativo', CURDATE(), ?, ?)`,
      [nome, endereco.insertId, fkEmpresa]
    );

    await conexao.commit();

    return {
      id_estacionamento: estacionamento.insertId,
      fk_endereco: endereco.insertId,
      fk_empresa: fkEmpresa,
    };
  } catch (erro) {
    await conexao.rollback();
    throw erro;
  } finally {
    conexao.release();
  }
}

module.exports = { buscarEmpresaPorCodigo, cadastrar };