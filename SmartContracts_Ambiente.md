# Exemplos de Smart Contracts para a Gestão Ambiental

Smart contracts, que são contratos autoexecutáveis codificados em plataformas blockchain, como Ethereum, oferecem mecanismos imutáveis, automatizados e transparentes que podem reduzir burocracia, aumentar a responsabilidade e incentivar práticas sustentáveis. Eles são executados automaticamente quando condições predefinidas são atendidas, frequentemente verificadas por fontes externas de dados (oráculos), tornando-os ideais para governança ambiental, onde confiança e verificação são essenciais.

## 1. **Smart Contracts para Gestão e Rastreabilidade de Resíduos Sólidos**
Este tipo de smart contract poderia automatizar o rastreamento e a incentivação da coleta, transporte e destinação de resíduos em ambientes urbanos ou rurais. Por exemplo, o contrato poderia liberar pagamentos a prestadores de serviço apenas após a verificação de manejo adequado dos resíduos, utilizando sensores IoT em veículos de coleta ou locais de descarte para confirmar conformidade com normas ambientais (como taxas de reciclagem ou prevenção de descarte ilegal).

   - **Inovação**: O contrato introduz descentralização e rastreabilidade em tempo real, reduzindo fraudes e corrupção em contratos públicos de resíduos. Integrado a aplicativos de denúncia cidadã, poderia também recompensar comunidades por participação, promovendo um modelo de governança participativa alinhado aos princípios da Governança na Era Digital.
   - **Contexto Brasileiro**: Na região amazônica, onde o descarte ilegal agrava o desmatamento e a poluição, esse modelo poderia estruturar um Sistema Integrado de Gestão de Resíduos Sólidos (SIGRS) para órgãos governamentais. Módulos para gerenciamento de contratos, transparência em auditorias e engajamento cidadão poderiam abordar as baixas taxas de manejo adequado de resíduos no Brasil (apenas cerca de 32,5% dos resíduos gerados são gerenciados corretamente).  Esse exemplo demonstra como o blockchain pode apoiar os Objetivos de Desenvolvimento Sustentável (ODS) 11 e 12 em municípios brasileiros.

## 2. **Smart Contracts para Licitações Públicas Sustentáveis com Critérios Ambientais**
Aqui, smart contracts poderiam incorporar salvaguardas ambientais em processos de licitação e execução de obras públicas, como na construção de rodovias. O contrato seria programado para impor cláusulas relacionadas à eficiência de recursos, minimização de resíduos e redução de emissões, suspendendo pagamentos caso as emissões de CO2 excedam limites verificados por registros de transporte.

   - **Inovação**: A automação de inspeções e auditorias por meio de regras autoexecutáveis minimiza a intervenção humana, combatendo o greenwashing e garantindo conformidade. A imutabilidade do blockchain cria registros à prova de adulteração, aumentando a transparência nas licitações e alinhando-se a plataformas nacionais, como o Portal Nacional de Contratações Públicas (PNCP).
   - **Contexto Brasileiro**: Sob a Lei nº 14.133/2021, que promove contratações sustentáveis, isso poderia ser aplicado a obras rodoviárias em áreas ambientalmente sensíveis, como o Pantanal ou o Cerrado. O modelo aborda problemas como o uso ineficiente de recursos em construções, onde violações ambientais são comuns, integrando critérios para redução de gases de efeito estufa e medidas corretivas.  Esse contrato inovaria ao descentralizar a fiscalização, reduzindo potencialmente o impacto ambiental de obras públicas na economia em crescimento do Brasil.

## 3. **Smart Contracts para Recompensas por Conservação e Comércio de Créditos de Carbono**
Esses contratos poderiam facilitar programas automatizados de recompensas por preservação de ecossistemas, como pagamentos por evitar desmatamento ou manter a biodiversidade. Utilizando imagens de satélite (via oráculos) para verificar mudanças no uso da terra, o contrato liberaria fundos ou tokens para proprietários de terras ou comunidades indígenas quando metas de conservação fossem alcançadas, como a manutenção da cobertura florestal por um período determinado.

   - **Inovação**: Ao criar créditos verificáveis e negociáveis (como offsets de biodiversidade ou carbono), o contrato combate fraudes em mercados voluntários e permite participação global por meio de ativos tokenizados. Smart contracts garantem que as recompensas sejam emitidas apenas com verificação de dados objetivos, construindo confiança no financiamento da conservação.
   - **Contexto Brasileiro**: Com o Brasil abrigando a maior floresta tropical do mundo, isso se alinha a iniciativas como o Tropical Forests Forever Facility ou programas estaduais em Mato Grosso.  Plataformas como a Ekonavi, sediada no Brasil, já utilizam smart contracts semelhantes para recompensas de conservação em vários continentes, o que poderia ser expandido para apoiar discussões da COP30 sobre créditos de carbono.  Esse tipo exemplifica inovação em Pagamentos por Serviços Ecossistêmicos (PSA), abordando as taxas de desmatamento na Amazônia e integrando-se ao arcabouço REDD+ do Brasil.

## 4. **Smart Contracts para Combate ao Greenwashing em Relatórios Ambientais**
Projetados para verificar alegações ambientais corporativas, esses contratos poderiam automatizar a auditoria de relatórios ao exigir que dados (como relatórios de emissões) passem por regras de validação predefinidas antes da aceitação. Se discrepâncias forem detectadas, como classificações inadequadas de atividades "verdes", o contrato poderia sinalizar problemas ou reter certificações.

   - **Inovação**: Oferece detecção de riscos em tempo real para tipos de greenwashing, como divulgação seletiva ou promessas vazias, usando o blockchain para fornecer evidências imutáveis a stakeholders (reguladores, ONGs). Isso transforma a responsabilidade ambiental de reativa para proativa.
   - **Contexto Brasileiro**: Relevante para setores como mineração e energia, onde casos como as falhas de divulgação de segurança de barragens da Vale S.A. destacam problemas de transparência.  No ambiente regulatório brasileiro, isso poderia se integrar aos padrões do IBAMA (Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis), inovando relatórios de sustentabilidade corporativa sob pressões ESG crescentes.

## 5. Exemplos em Solidity

Cada exemplo inclui comentários em português para explicar o código. Recomendo testar esses contratos em um ambiente de desenvolvimento como Remix IDE, integrando oráculos (ex.: Chainlink) para dados externos, como verificações ambientais do IBAMA ou INPE. Lembre-se de que, em produção, seria necessário auditoria de segurança e conformidade legal.

### 1. **Smart Contracts para Gestão e Rastreabilidade de Resíduos Sólidos**
Este contrato simula o rastreamento de resíduos sólidos, liberando pagamentos apenas após verificação de conformidade com a Política Nacional de Resíduos Sólidos (Lei nº 12.305/2010). Ele usa um oráculo para confirmar dados de sensores IoT sobre coleta e descarte adequado, evitando descarte ilegal em áreas como a Amazônia.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GestaoResiduosSolidos {
    address public proprietario; // Proprietário do contrato (ex.: Prefeitura Municipal)
    mapping(address => uint256) public pagamentosPendentes; // Pagamentos pendentes para prestadores de serviço
    uint256 public taxaReciclagemMinima = 30; // Taxa mínima de reciclagem conforme PNRS (em %)

    event ColetaVerificada(address prestador, uint256 valorLiberado);
    event DescumprimentoDetectado(address prestador, string motivo);

    constructor() {
        proprietario = msg.sender;
    }

    // Função para registrar coleta e verificar conformidade via oráculo
    function verificarColeta(address prestador, uint256 taxaReciclagem, uint256 valorPagamento) public {
        require(msg.sender == proprietario, "Apenas o proprietario pode verificar"); // Conformidade com governança pública
        if (taxaReciclagem >= taxaReciclagemMinima) {
            pagamentosPendentes[prestador] += valorPagamento;
            emit ColetaVerificada(prestador, valorPagamento);
        } else {
            emit DescumprimentoDetectado(prestador, "Taxa de reciclagem abaixo do minimo conforme Lei 12.305/2010");
        }
    }

    // Função para liberar pagamento após confirmação ambiental (simulada)
    function liberarPagamento(address prestador) public {
        require(msg.sender == proprietario, "Apenas o proprietario pode liberar");
        uint256 valor = pagamentosPendentes[prestador];
        require(valor > 0, "Nenhum pagamento pendente");
        pagamentosPendentes[prestador] = 0;
        payable(prestador).transfer(valor); // Transferência para prestador de serviço
    }
}
```

Essa funcionalidade automatiza a verificação de "manejo adequado de resíduos sólidos", reduzindo fraudes e alinhando-se ao SIGRS (Sistema Integrado de Gestão de Resíduos Sólidos). 

### 2. **Smart Contracts para Licitações Públicas Sustentáveis com Critérios Ambientais**
Este contrato incorpora critérios ambientais em licitações, conforme a Lei nº 14.133/2021 (Nova Lei de Licitações e Contratos Administrativos), suspendendo pagamentos se emissões de CO2 excederem limites verificados por oráculos (ex.: dados de transporte do IBAMA).

```solidity
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
```

Aqui, a automação reflete "cláusulas de sustentabilidade" na lei, promovendo eficiência em obras como rodovias no Pantanal. 

### 3. **Smart Contracts para Recompensas por Conservação e Comércio de Créditos de Carbono**
Este contrato automatiza pagamentos por conservação, alinhado ao REDD+ e à Lei nº 6.938/1981 (Política Nacional do Meio Ambiente), usando oráculos para verificar cobertura florestal via INPE e emitindo tokens como créditos de carbono.

```solidity
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
```

Essa inovação tokeniza "Pagamentos por Serviços Ecossistêmicos (PSA)", combatendo desmatamento na Amazônia.  

### 4. **Smart Contracts para Combate ao Greenwashing em Relatórios Ambientais**
Este contrato verifica relatórios ambientais, conforme padrões do IBAMA e Lei nº 9.605/1998 (Lei de Crimes Ambientais), sinalizando discrepâncias em alegações "verdes" via oráculos com IA para validação.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AntiGreenwashing {
    address public regulador; // Regulador (ex.: IBAMA ou CVM)
    mapping(address => bool) public relatorioValidado; // Status de validação para empresas
    string public criterioVerde = "Atividades com reducao de emissões comprovada"; // Critério ambiental

    event DiscrepanciaDetectada(address empresa, string descricao);
    event RelatorioAprovado(address empresa);

    constructor() {
        regulador = msg.sender;
    }

    // Função para submeter e verificar relatório via oráculo
    function submeterRelatorio(address empresa, string memory dadosEmissoes) public {
        require(msg.sender == empresa, "Apenas a empresa pode submeter");
        // Simulação de verificação: em produção, usar oráculo para checar dados
        if (keccak256(abi.encodePacked(dadosEmissoes)) == keccak256(abi.encodePacked(criterioVerde))) {
            relatorioValidado[empresa] = true;
            emit RelatorioAprovado(empresa);
        } else {
            relatorioValidado[empresa] = false;
            emit DiscrepanciaDetectada(empresa, "Discrepancia em alegacoes verdes conforme Lei 9.605/1998");
        }
    }

    // Função para consultar status e reter certificação se inválido
    function consultarCertificacao(address empresa) public view returns (bool) {
        require(msg.sender == regulador, "Apenas regulador pode consultar");
        return relatorioValidado[empresa];
    }
}
```

Isso promove transparência em setores como mineração, evitando greenwashing como em casos da Vale S.A. 






