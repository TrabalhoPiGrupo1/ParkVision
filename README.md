<div align="center">

<img src="Public/Assets/Icons/logo.png" alt="ParkVision" width="250">

**Sistema de monitoramento de vagas em estacionamentos privados na cidade de São Paulo**

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)

Projeto acadêmico da **São Paulo Tech School (SPTECH)** · Faculdade de Tecnologia · 2026

</div>

---

## 📌 Sobre o projeto

O **ParkVision** é um protótipo de sistema IoT que monitora a ocupação de vagas de estacionamento e transforma a ocupação física em dados digitais, que podem ser armazenados, visualizados e analisados por meio de uma plataforma web.

Sensores ultrassônicos ligados a um microcontrolador detectam se uma vaga está **ocupada** ou **livre**. Os dados são enviados por API, guardados em um banco MySQL e exibidos em um dashboard com gráficos e indicadores, para que o gestor do estacionamento acompanhe a utilização das vagas em tempo real e consulte o histórico.

## ❗ Problema

Estacionamentos privados de médio e grande porte enfrentam uma demanda que oscila ao longo do dia e da semana, mas costumam praticar **tarifas fixas**. O resultado são dois problemas opostos:

- **Saturação** nos horários de pico, quando novos clientes têm dificuldade de estacionar;
- **Ociosidade silenciosa** fora do pico, quando vagas livres deixam de gerar receita.

Sem acompanhamento contínuo, o gestor depende da observação e da experiência para identificar esses períodos. Por exemplo, com a tarifa mediana de R$ 15,00 por hora em São Paulo (CarPass), um estacionamento de 35 vagas com apenas 5 ocupadas fatura R$ 75,00 por hora, enquanto 30 vagas ficam sem uso.

## 🎯 Objetivo

Desenvolver e validar, **até 7 de dezembro de 2026**, um protótipo IoT com sensores ultrassônicos, microcontrolador e plataforma web com dashboards, capaz de coletar, registrar e exibir em tempo real o status de ocupação e ociosidade de vagas, além de manter o histórico para análise de tendências de demanda.

Com isso, o administrador ganha base de dados para apoiar decisões de gestão, como a **precificação dinâmica**. A decisão de alterar preços continua sendo do gestor; o sistema não a executa sozinho.

## ✨ Funcionalidades

- Detecção de vaga **ocupada/livre** com sensor ultrassônico HC-SR04
- Envio e armazenamento dos dados em banco MySQL (servidor Linux)
- Site institucional
- Cadastro e login de usuários
- Dashboard com status da vaga em tempo real
- Indicadores: percentual de ocupação e ociosidade, tempo de uso e períodos de maior e menor demanda
- Histórico de ocupação para consulta

## 🏗️ Arquitetura da solução

```
Sensor ultrassônico HC-SR04
          ↓
       Arduino
          ↓
Computador com aplicação Node.js (API Data-Acquino)
          ↓
  Banco de dados MySQL (VM Linux)
          ↓
      API Web-Dataviz
          ↓
Site institucional  +  Dashboard
```

## 🛠️ Tecnologias

| Camada | Tecnologias |
|--------|-------------|
| Hardware | Arduino, sensor ultrassônico HC-SR04 |
| Front-end | HTML, CSS, JavaScript |
| Back-end | Node.js |
| Banco de dados | MySQL |
| Infraestrutura | Servidor Linux (VM Lubuntu) |
| Design | Figma |
| Gestão do projeto | Trello (Kanban), planilha de backlog, GitHub |

## 👥 Integrantes

| Nome |
|------|
| Camilly Rodrigues Felix de Jesus |
| Gabriel Borges dos Santos |
| Guilherme Sanches Matias |
| Júlia Siécola Matiussi |
| Mirela Martins de Carvalho |
| Yan Silva Gutmann |

## 📚 Referências

- [Modelos de otimização de preço dinâmico para estacionamento (arXiv)](https://arxiv.org/html/2208.14231v1#bib.bib30)
- [Frota de veículos em São Paulo (IBGE)](https://cidades.ibge.gov.br/brasil/sp/pesquisa/22/28120)
- [Quanto custa estacionar em São Paulo por bairro (CarPass)](https://www.carpass.in/blog/quanto-custa-estacionar-em-sao-paulo-por-bairro)
- [Preço dinâmico no estacionamento (CloudPark)](https://cloudpark.com.br/preco-dinamico-no-estacionamento/)

---

<div align="center">

**SPTECH · São Paulo Tech School** — Faculdade de Tecnologia

</div>
