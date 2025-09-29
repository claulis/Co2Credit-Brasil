// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // Para tokens de créditos de carbono

contract RecompensasConservacao is ERC20 {
    address public administrador; // Administrador (ex.: Fundo Amazônia ou IBAMA)
    uint256 public coberturaFlorestalMinima = 80; // Cobertura mínima em % para recompensa
    mapping(address => bool) public metasAlcancadas; // Status de conservação para proprietários

    event RecompensaEmitida(address beneficiario, uint256 tokens);
    event VerificacaoFalha(address beneficiario, string motivo);

    constructor() ERC20("CreditoCarbonoBR", "CCBR") {
        administrador = msg.sender;
        _mint(address(this), 1000000 * 10 ** decimals()); // Mint inicial de tokens
    }

    // Função para verificar conservação via oráculo (ex.: satélites INPE)
    function verificarConservacao(address beneficiario, uint256 coberturaMedida) public {
        require(msg.sender == administrador, "Apenas administrador pode verificar");
        if (coberturaMedida >= coberturaFlorestalMinima) {
            metasAlcancadas[beneficiario] = true;
            emit RecompensaEmitida(beneficiario, 100); // Exemplo: 100 tokens por meta
        } else {
            emit VerificacaoFalha(beneficiario, "Cobertura florestal abaixo do minimo conforme REDD+");
        }
    }

    // Função para transferir recompensa se meta alcançada
    function transferirRecompensa(address beneficiario) public {
        require(msg.sender == administrador, "Apenas administrador pode transferir");
        require(metasAlcancadas[beneficiario], "Meta de conservacao nao alcancada");
        _transfer(address(this), beneficiario, 100 * 10 ** decimals());
    }
}