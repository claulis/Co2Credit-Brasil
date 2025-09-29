# Smart Contracts

*Smart contracts* (ou contratos inteligentes) são programas de computador autoexecutáveis armazenados em uma blockchain, que executam ações automaticamente quando condições predefinidas, codificadas no contrato, são atendidas. Eles funcionam como acordos digitais que eliminam a necessidade de intermediários, como bancos, advogados ou cartórios, ao garantir que as regras do contrato sejam cumpridas de forma transparente, segura e imutável.

A expressão "smart contract" foi cunhada por Nick Szabo em 1994, que os descreveu como "protocolos computadorizados que executam os termos de um contrato". Embora inicialmente teóricos, os *smart contracts* ganharam aplicação prática com blockchains como o Ethereum, que oferecem ambientes programáveis para sua execução.

## 1. **Características principais**

1. **Autoexecução**: Os *smart contracts* executam ações automaticamente quando suas condições são atendidas (ex.: "se receber 1 ETH, então transferir um token"). Não dependem de intervenção humana, reduzindo custos e atrasos.

2. **Descentralização**: São armazenados e executados em uma blockchain, como Ethereum, Cardano ou Binance Smart Chain, em uma rede de computadores (nós) distribuídos globalmente. Isso elimina a necessidade de uma autoridade central e aumenta a resistência à censura.

3. **Imutabilidade**: Após serem implantados na blockchain, os *smart contracts* geralmente não podem ser alterados, garantindo que as regras acordadas permaneçam inalteradas. Exceções existem em contratos projetados para serem atualizáveis, mas isso exige planejamento específico.

4. **Transparência**: O código do contrato é, na maioria dos casos, público e pode ser auditado por qualquer pessoa, promovendo confiança. Todas as transações relacionadas ao contrato são registradas na blockchain, visíveis e verificáveis.

5. **Segurança**: A execução é protegida pela criptografia da blockchain, tornando os *smart contracts* resistentes a manipulações (desde que bem codificados). 

6. **Determinismo**: Os *smart contracts* produzem o mesmo resultado em todos os nós da rede, garantindo consistência na execução.

## .2 Como funcionam os Smart Contracts?

1. **Criação**:
   - Um desenvolvedor escreve o *smart contract* em uma linguagem de programação compatível com a blockchain (ex.: Solidity para Ethereum).
   - O contrato define condições e ações (ex.: "se A pagar X, então transferir Y para B").

2. **Implantação**:
   - O contrato é compilado e enviado para a blockchain, onde é armazenado em um endereço único.
   - Essa implantação requer uma transação, que consome recursos computacionais (no Ethereum, pago em *gas*).

3. **Execução**:
   - Usuários interagem com o contrato enviando transações para seu endereço na blockchain.
   - Quando as condições codificadas são atendidas, o contrato executa as ações automaticamente (ex.: transferir fundos, emitir um token, registrar um voto).
   - A execução é validada por todos os nós da rede, garantindo consenso.

4. **Registro**:
   - Todas as ações do contrato são registradas na blockchain, criando um histórico imutável e transparente.

## 3. Exemplo de código (Solidity)

Aqui está um exemplo básico de um *smart contract* em Solidity, para ilustrar sua estrutura:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato simples para transferência de ETH com mensagens em português
contract TransferenciaSimples {
    // Endereço do administrador (quem implanta o contrato)
    address public administrador;

    // Saldo disponível no contrato
    uint256 public saldo;

    // Evento para notificar depósito
    event DepositoRealizado(address indexed remetente, uint256 valor, string mensagem);

    // Evento para notificar transferência
    event TransferenciaRealizada(address indexed destinatario, uint256 valor, string mensagem);

    // Construtor: define o administrador como quem implanta o contrato
    constructor() {
        administrador = msg.sender;
    }

    // Modificador: garante que apenas o administrador execute a função
    modifier somenteAdministrador() {
        require(msg.sender == administrador, "Somente o administrador pode executar esta funcao");
        _;
    }

    // Função para depositar ETH no contrato
    function depositar() public payable {
        require(msg.value > 0, "O valor a depositar deve ser maior que zero");
        
        // Atualiza o saldo do contrato
        saldo += msg.value;

        // Emite evento com mensagem
        emit DepositoRealizado(msg.sender, msg.value, "Deposito concluido com sucesso");
    }

    // Função para transferir ETH do contrato para um destinatário
    function transferir(address payable _destinatario, uint256 _valor) public somenteAdministrador {
        require(_valor > 0, "O valor a transferir deve ser maior que zero");
        require(_valor <= saldo, "Saldo insuficiente no contrato");

        // Reduz o saldo antes da transferência para evitar reentrância
        saldo -= _valor;

        // Realiza a transferência
        _destinatario.transfer(_valor);

        // Emite evento com mensagem
        emit TransferenciaRealizada(_destinatario, _valor, "Transferencia concluida com sucesso");
    }

    // Função para consultar o saldo do contrato
    function consultarSaldo() public view returns (uint256) {
        return saldo;
    }
}
```

## 4. Vamos programar 

1. Copie o codigo acima e abra o [![Remix IDE](https://img.shields.io/badge/Remix_IDE-Abrir-blue?logo=ethereum)](https://remix.ethereum.org)

2. Crie um arquivo chamado `TransfereciaSimples.sol` no **File Explorer**, cole o código copiado.

3. Compile o contrato

4. Faça o deploy em uma TestNet qualquer a disposição

5. Interaja com sua interface
