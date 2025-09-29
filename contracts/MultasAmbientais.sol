// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultasAmbientais {
    address public fiscalizador; // Fiscalizador ambiental (ex.: IBAMA ou órgão estadual)
    mapping(address => uint256) public multasPendentes; // Multas pendentes por infrator (empresa ou indivíduo)
    uint256 public valorMultaBase = 1000 ether; // Valor base da multa em wei (simulado; na prática, ajuste para R$ conforme Lei 9.605/1998)
    uint256 public limiteViolacao = 50; // Limite de violação (ex.: emissões em toneladas ou área desmatada em hectares)
    bool public violacaoDetectada; // Status de violação verificado via oráculo

    event MultaAplicada(address infrator, uint256 valor, string motivo);
    event PagamentoEfetuado(address infrator, uint256 valorPago);
    event ReducaoConcedida(address infrator, uint256 reducao);

    constructor() {
        fiscalizador = msg.sender;
        violacaoDetectada = false;
    }

    // Função para verificar violação ambiental via oráculo (ex.: dados de satélite INPE ou sensores IoT)
    function verificarViolacao(address infrator, uint256 nivelMedido, string memory descricaoViolacao) public {
        require(msg.sender == fiscalizador, "Apenas o fiscalizador pode verificar violacoes");
        if (nivelMedido > limiteViolacao) {
            violacaoDetectada = true;
            uint256 valorMulta = valorMultaBase * (nivelMedido / limiteViolacao); // Multa proporcional à gravidade, conforme art. 3º da Lei 9.605/1998
            multasPendentes[infrator] += valorMulta;
            emit MultaAplicada(infrator, valorMulta, descricaoViolacao); // Ex.: "Desmatamento ilegal na Amazonia"
        } else {
            violacaoDetectada = false;
        }
    }

    // Função para pagamento da multa com possível redução por correção voluntária (ex.: reflorestamento comprovado)
    function pagarMulta() public payable {
        uint256 multaDevida = multasPendentes[msg.sender];
        require(multaDevida > 0, "Nenhuma multa pendente");
        require(msg.value >= multaDevida, "Valor insuficiente para pagamento");

        // Simulação de redução: se correção voluntária, reduzir em 20% (inspirado em mecanismos de leniência ambiental)
        uint256 valorFinal = multaDevida;
        if (verificarCorrecaoVoluntaria(msg.sender)) { // Função simulada; em produção, usar oráculo para prova de correção
            uint256 reducao = (multaDevida * 20) / 100;
            valorFinal -= reducao;
            emit ReducaoConcedida(msg.sender, reducao);
        }

        require(msg.value >= valorFinal, "Valor insuficiente apos reducao");
        multasPendentes[msg.sender] = 0;
        payable(fiscalizador).transfer(valorFinal); // Transferência para o fiscalizador (ex.: fundo ambiental)
        if (msg.value > valorFinal) {
            payable(msg.sender).transfer(msg.value - valorFinal); // Devolução de excesso
        }
        emit PagamentoEfetuado(msg.sender, valorFinal);
    }

    // Função auxiliar simulada para verificar correção voluntária (ex.: comprovação de reflorestamento)
    function verificarCorrecaoVoluntaria(address infrator) internal view returns (bool) {
        // Em produção, integrar oráculo para dados reais do IBAMA
        return true; // Simulação para fins educacionais
    }

    // Função para o fiscalizador retirar fundos acumulados (ex.: para Fundo Nacional do Meio Ambiente)
    function retirarFundos() public {
        require(msg.sender == fiscalizador, "Apenas o fiscalizador pode retirar fundos");
        payable(fiscalizador).transfer(address(this).balance);
    }
}