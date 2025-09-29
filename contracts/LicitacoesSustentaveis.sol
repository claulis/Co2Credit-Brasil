// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LicitacoesSustentaveis {
    address public orgaoPublico; // Órgão público responsável (ex.: Ministério da Infraestrutura)
    uint256 public limiteEmissoesCO2 = 100; // Limite de emissões em toneladas, conforme critérios ESG
    mapping(address => uint256) public tranchesPagamento; // Parcelas de pagamento para empreiteiras
    bool public conformidadeAmbiental; // Status de conformidade verificado

    event PagamentoSuspenso(address empreiteira, string motivo);
    event TrancheLiberada(address empreiteira, uint256 valor);

    constructor() {
        orgaoPublico = msg.sender;
        conformidadeAmbiental = false;
    }

    // Função para verificar emissões via oráculo e atualizar status
    function verificarEmissoes(uint256 emissoesMedidas) public {
        require(msg.sender == orgaoPublico, "Apenas o orgao publico pode verificar");
        if (emissoesMedidas <= limiteEmissoesCO2) {
            conformidadeAmbiental = true;
        } else {
            conformidadeAmbiental = false;
            emit PagamentoSuspenso(msg.sender, "Emissoes de CO2 excedem limite conforme Lei 14.133/2021");
        }
    }

    // Função para liberar tranche de pagamento se conforme
    function liberarTranche(address empreiteira, uint256 valor) public {
        require(msg.sender == orgaoPublico, "Apenas o orgao publico pode liberar");
        require(conformidadeAmbiental, "Conformidade ambiental nao verificada");
        tranchesPagamento[empreiteira] += valor;
        payable(empreiteira).transfer(valor);
        emit TrancheLiberada(empreiteira, valor);
    }
}