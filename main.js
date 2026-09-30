// importa as bibliotecas necessárias
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERVIDOR_PORTA = 3300;
const INTERVALO_SIMULACAO_MS = 3000; // Simula a leitura a cada 3 segundos

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// Conexão com o banco de dados MySQL
const poolBancoDados = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'musica.minecraft@111204',
    database: 'estacionamento',
    port: 3306
}).promise();

// Função para simular o sensor digital de vaga do Arduino
const simularArduinoEstacionamento = (valoresSensorDigital) => {
    console.log(`[SIMULAÇÃO] Monitorando vaga a cada ${INTERVALO_SIMULACAO_MS / 1000}s...`);

    setInterval(async () => {
        // Gera true (ocupada) ou false (livre)
        const vagaOcupada = Math.random() < 0.5;

        // Armazena o booleano no array em memória
        valoresSensorDigital.push(vagaOcupada);

        console.log(`[VAGA] Status: ${vagaOcupada ? 'OCUPADA (true)' : 'LIVRE (false)'}`);

        // Insere o dado no banco de dados (se habilitado)
        if (HABILITAR_OPERACAO_INSERIR) {
            try {
                await poolBancoDados.execute(
                    'INSERT INTO medida (sensor_digital) VALUES (?)',
                    [vagaOcupada]
                );
                console.log(`[BANCO] Registrado: ${vagaOcupada}`);
            } catch (error) {
                console.error('[ERRO BANCO]', error.message);
            }
        }
    }, INTERVALO_SIMULACAO_MS);
};

// Função para criar e configurar o servidor Web API
const servidor = (valoresSensorDigital) => {
    const app = express();

    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API de Estacionamento rodando na porta ${SERVIDOR_PORTA}`);
    });

    // Retorna todo o histórico de estados da vaga (Array de booleanos)
    app.get('/sensores/digital', (_, response) => {
        return response.json(valoresSensorDigital);
    });

    // Retorna apenas o estado atual instantâneo da vaga
    app.get('/sensores/vaga/atual', (_, response) => {
        const ultimoStatus = valoresSensorDigital[valoresSensorDigital.length - 1] ?? false;

        return response.json({
            ocupada: ultimoStatus,
            atualizadoEm: new Date().toISOString()
        });
    });
};

// Execução principal
(() => {
    const valoresSensorDigital = [];

    // Inicia a simulação
    simularArduinoEstacionamento(valoresSensorDigital);

    // Inicia o servidor Web
    servidor(valoresSensorDigital);
})();