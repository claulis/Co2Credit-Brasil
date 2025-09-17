Claro! Vamos **refazer tudo usando Hardhat (para blockchain), Express.js (backend) e EJS (frontend server-side)** — mantendo o mesmo objetivo: um **sistema público de créditos de carbono em blockchain**, totalmente funcional, deployado na **testnet Polygon Mumbai**, e **acessível para qualquer pessoa testar**.

---

# 🌿 SISTEMA “CARBONTRACK BRASIL” — VERSÃO COM EXPRESS + EJS + HARDHAT

## ✅ OBJETIVO

Substituir o frontend React por uma **aplicação server-side com EJS**, usar **Express como backend** para facilitar integração com blockchain, e manter o **contrato em Solidity via Hardhat**.

Ideal para:
- Projetos mais simples.
- Quem prefere backend tradicional.
- Aplicações que não precisam de SPA complexa.
- Integração direta com carteiras via server-side (MetaMask via client).

---

# 🧱 ARQUITETURA ATUALIZADA

```
┌──────────────────────────────────────────────┐
│           FRONTEND (EJS + Express)           │ ← Renderizado no servidor
│  - Páginas dinâmicas com dados da chain      │
│  - Formulários para emitir/aposentar         │
└───────────────┬──────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────┐
│           BACKEND (Express.js)               │ ← Lógica de integração
│  - Conecta ao contrato via ethers.js         │
│  - Manipula chamadas e eventos               │
└───────────────┬──────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────┐
│           SMART CONTRACT (Hardhat)           │ ← ERC-721 em Solidity
│  - Deploy na Polygon Mumbai                  │
│  - Armazena estado e regras de negócio       │
└───────────────┬──────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────┐
│           BLOCKCHAIN (Polygon Mumbai)        │ ← Testnet pública
│  - Transações públicas e auditáveis          │
└──────────────────────────────────────────────┘
```

---

# 🛠️ TECNOLOGIAS

| Camada          | Tecnologia                         |
|-----------------|------------------------------------|
| Blockchain      | Polygon Mumbai (testnet pública)   |
| Contrato        | Solidity + Hardhat + OpenZeppelin   |
| Backend         | Express.js + Ethers.js             |
| Frontend        | EJS (Embedded JavaScript Templates) |
| Deploy          | Render, Railway, ou localhost      |
| Carteira        | MetaMask (via client-side signer)  |

> ⚠️ **IMPORTANTE**: Mesmo com EJS, a assinatura de transações **sempre ocorre no cliente (MetaMask)** — o backend só facilita leitura e preparação de calls.

---

# 📁 ESTRUTURA DO PROJETO

```
carbontrack-express/
├── contracts/
│   └── CarbonCreditNFT.sol          # mesmo contrato ERC-721
├── scripts/
│   └── deploy.js                    # deploy Hardhat
├── backend/
│   ├── routes/
│   │   └── carbon.js                # rotas de emissão, aposentadoria
│   ├── views/
│   │   ├── index.ejs
│   │   ├── credits.ejs
│   │   └── layouts/main.ejs
│   ├── public/
│   │   └── js/
│   │       └── wallet.js            # lógica client-side para MetaMask
│   ├── app.js                       # servidor Express
│   └── config.js                    # config do contrato e provider
├── hardhat.config.js
├── .env
└── package.json
```

---

# 📜 1. SMART CONTRACT — `contracts/CarbonCreditNFT.sol`

> **Mesmo contrato da entrega anterior** — compatível com EJS/Express.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract CarbonCreditNFT is ERC721, Ownable, IERC2981 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct CarbonCredit {
        address issuer;
        string projectId;
        string location;
        uint256 tonnesCO2;
        uint256 issuanceDate;
        uint256 retirementDate;
        bool isActive;
    }

    mapping(uint256 => CarbonCredit) private _credits;
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => bool) public authorizedIssuers;

    address public royaltyReceiver;
    uint96 public royaltyBps;

    event CreditIssued(uint256 indexed tokenId, address indexed issuer, address indexed owner, uint256 tonnesCO2);
    event CreditRetired(uint256 indexed tokenId, address indexed owner, uint256 retirementDate);

    constructor() ERC721("CarbonCreditNFT", "CCN") {
        _grantRole(msg.sender);
        royaltyReceiver = msg.sender;
        royaltyBps = 500;
    }

    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Não autorizado");
        _;
    }

    modifier onlyCreditOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "Não é dono");
        require(_credits[tokenId].isActive, "Inativo");
        _;
    }

    function addAuthorizedIssuer(address issuer) external onlyOwner {
        require(issuer != address(0), "Inválido");
        authorizedIssuers[issuer] = true;
    }

    function setRoyalty(address receiver, uint96 bps) external onlyOwner {
        require(receiver != address(0), "Receiver inválido");
        require(bps <= 10000, "Máx 100%");
        royaltyReceiver = receiver;
        royaltyBps = bps;
    }

    function issueCredit(
        address to,
        string memory projectId,
        string memory location,
        uint256 tonnesCO2
    ) external onlyAuthorizedIssuer returns (uint256) {
        require(to != address(0), "Destinatário inválido");
        require(bytes(projectId).length > 0, "Projeto obrigatório");
        require(tonnesCO2 > 0, "Quantidade > 0");

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(to, tokenId);

        _credits[tokenId] = CarbonCredit({
            issuer: msg.sender,
            projectId: projectId,
            location: location,
            tonnesCO2: tonnesCO2,
            issuanceDate: block.timestamp,
            retirementDate: 0,
            isActive: true
        });

        emit CreditIssued(tokenId, msg.sender, to, tonnesCO2);
        return tokenId;
    }

    function retireCredit(uint256 tokenId) external onlyCreditOwner(tokenId) {
        _credits[tokenId].isActive = false;
        _credits[tokenId].retirementDate = block.timestamp;
        emit CreditRetired(tokenId, msg.sender, block.timestamp);
    }

    function setTokenURI(uint256 tokenId, string memory ipfsUri) external onlyOwner {
        require(_exists(tokenId), "Token não existe");
        _tokenURIs[tokenId] = ipfsUri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token não existe");
        string memory uri = _tokenURIs[tokenId];
        return bytes(uri).length > 0 ? uri : "https://ipfs.io/ipfs/Qm...";
    }

    function royaltyInfo(uint256, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        return (royaltyReceiver, (salePrice * royaltyBps) / 10000);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, IERC165)
        returns (bool)
    {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function _grantRole(address account) internal {
        authorizedIssuers[account] = true;
    }
}
```

---

# ⚙️ 2. CONFIGURAÇÃO DO HARDHAT

### `hardhat.config.js`

```js
require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    mumbai: {
      url: process.env.POLYGON_MUMBAI_RPC || "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
```

### `.env`

```env
PRIVATE_KEY=0x...sua_chave_privada_de_teste
POLYGON_MUMBAI_RPC=https://rpc-mumbai.maticvigil.com
CONTRACT_ADDRESS=0x... # preencha após deploy
```

### `scripts/deploy.js`

```js
const { ethers } = require("hardhat");

async function main() {
  const CarbonCreditNFT = await ethers.getContractFactory("CarbonCreditNFT");
  const contract = await CarbonCreditNFT.deploy();

  await contract.waitForDeployment();

  console.log("✅ Contrato implantado em:", await contract.getAddress());
}

main().catch(console.error);
```

> 💡 Rode: `npx hardhat run scripts/deploy.js --network mumbai`

---

# 🖥️ 3. BACKEND EXPRESS + EJS

### `backend/package.json`

```json
{
  "name": "carbontrack-backend",
  "version": "1.0.0",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "ejs": "^3.1.9",
    "ethers": "^6.11.1",
    "dotenv": "^16.4.5"
  }
}
```

---

### `backend/config.js`

```js
require('dotenv').config();

const { ethers } = require("ethers");

const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const CONTRACT_ABI = require('../artifacts/contracts/CarbonCreditNFT.sol/CarbonCreditNFT.json').abi;

const provider = new ethers.JsonRpcProvider(process.env.POLYGON_MUMBAI_RPC);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

module.exports = {
  provider,
  wallet,
  contract,
  CONTRACT_ADDRESS,
  CONTRACT_ABI
};
```

> ⚠️ Após deploy, copie o endereço para `.env` e gere o ABI em `artifacts/`.

---

### `backend/app.js`

```js
const express = require('express');
const path = require('path');
const config = require('./config');

const app = express();
const port = process.env.PORT || 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));

// Rotas
app.use('/', require('./routes/carbon'));

app.listen(port, () => {
  console.log(`✅ Servidor rodando em http://localhost:${port}`);
  console.log(`🔗 Contrato: ${config.CONTRACT_ADDRESS}`);
});
```

---

### `backend/routes/carbon.js`

```js
const express = require('express');
const router = express.Router();
const { contract, CONTRACT_ADDRESS, CONTRACT_ABI } = require('../config');
const { ethers } = require('ethers');

// Página inicial
router.get('/', async (req, res) => {
  try {
    const totalSupply = Number(await contract.totalSupply ? await contract.totalSupply() : 0);
    res.render('index', { contractAddress: CONTRACT_ADDRESS, totalSupply });
  } catch (err) {
    res.render('index', { contractAddress: CONTRACT_ADDRESS, totalSupply: 0, error: err.message });
  }
});

// Emitir crédito (renderiza formulário)
router.get('/issue', (req, res) => {
  res.render('issue', { contractAddress: CONTRACT_ADDRESS });
});

// Processar emissão (simulação — transação via client)
router.post('/issue', (req, res) => {
  const { projectId, location, tonnes, to } = req.body;
  // Envia dados para o frontend assinar
  res.render('confirm', {
    action: 'issue',
    data: { projectId, location, tonnes, to },
    contractAddress: CONTRACT_ADDRESS,
    abi: JSON.stringify(CONTRACT_ABI)
  });
});

// Aposentar crédito
router.post('/retire', (req, res) => {
  const { tokenId } = req.body;
  res.render('confirm', {
    action: 'retire',
    data: { tokenId },
    contractAddress: CONTRACT_ADDRESS,
    abi: JSON.stringify(CONTRACT_ABI)
  });
});

// Ver créditos (simulado — em produção, use balanceOf + tokenOfOwnerByIndex)
router.get('/credits', (req, res) => {
  // Simulação de dados
  const credits = [
    { id: 1, projectId: "AMZ-001", location: "AM-BR", tonnes: 1000, isActive: true },
    { id: 2, projectId: "MT-002", location: "MT-BR", tonnes: 500, isActive: false }
  ];
  res.render('credits', { credits, contractAddress: CONTRACT_ADDRESS });
});

module.exports = router;
```

---

# 🎨 4. FRONTEND COM EJS

### `backend/views/layouts/main.ejs`

```ejs
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarbonTrack Brasil</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f9f9f9; }
        .container { max-width: 800px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        input, button { padding: 10px; margin: 5px 0; width: 100%; box-sizing: border-box; }
        button { background: #28a745; color: white; border: none; cursor: pointer; }
        .credit { border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 8px; }
        .active { color: green; }
        .retired { color: red; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌱 CarbonTrack Brasil</h1>
        <p><em>Sistema de créditos de carbono em blockchain — Polygon Mumbai Testnet</em></p>
        <p>Contrato: <a href="https://mumbai.polygonscan.com/address/<%= contractAddress %>" target="_blank"><%= contractAddress %></a></p>
        <hr>
        <%- body %>
        <footer style="margin-top: 40px; font-size: 0.9em; color: #666;">
            <p>💧 Pegue MATIC grátis: <a href="https://mumbaifaucet.com" target="_blank">Mumbai Faucet</a></p>
        </footer>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.11.1/ethers.min.js"></script>
    <script src="/js/wallet.js"></script>
</body>
</html>
```

---

### `backend/views/index.ejs`

```ejs
<% include('layouts/main') %>

<h2>📊 Painel Inicial</h2>
<p>Total de créditos emitidos: <strong><%= totalSupply %></strong></p>

<a href="/issue"><button>Emitir Novo Crédito</button></a>
<a href="/credits"><button>Ver Meus Créditos</button></a>

<% if (error) { %>
    <p style="color: red;">Erro: <%= error %></p>
<% } %>
```

---

### `backend/views/issue.ejs`

```ejs
<% include('layouts/main') %>

<h2>➕ Emitir Novo Crédito</h2>
<form method="POST" action="/issue">
    <input name="to" placeholder="Endereço do destinatário (0x...)" required />
    <input name="projectId" placeholder="ID do Projeto (ex: AMZ-REF-2024)" required />
    <input name="location" placeholder="Localização (ex: AM-BR)" required />
    <input name="tonnes" type="number" placeholder="Toneladas CO₂e" min="1" required />
    <button type="submit">Preparar Transação</button>
</form>
```

---

### `backend/views/confirm.ejs`

```ejs
<% include('layouts/main') %>

<h2>✍️ Confirme a Transação no MetaMask</h2>
<p>Conecte sua carteira e assine a transação abaixo.</p>

<div id="status">Aguardando conexão com MetaMask...</div>

<script>
    const action = '<%= action %>';
    const data = <%- JSON.stringify(data) %>;
    const contractAddress = '<%= contractAddress %>';
    const abi = <%- abi %>;

    initWallet(action, data, contractAddress, abi);
</script>
```

---

### `backend/views/credits.ejs`

```ejs
<% include('layouts/main') %>

<h2>📋 Meus Créditos</h2>

<% if (credits.length === 0) { %>
    <p>Nenhum crédito encontrado.</p>
<% } else { %>
    <% credits.forEach(credit => { %>
        <div class="credit">
            <strong>Crédito #<%= credit.id %></strong><br>
            Projeto: <%= credit.projectId %><br>
            Local: <%= credit.location %><br>
            <%= credit.tonnes %> tCO₂e<br>
            Status: <span class="<%= credit.isActive ? 'active' : 'retired' %>">
                <%= credit.isActive ? '✅ Ativo' : '⛔ Aposentado' %>
            </span>
            <% if (credit.isActive) { %>
                <form method="POST" action="/retire" style="margin-top: 10px;">
                    <input type="hidden" name="tokenId" value="<%= credit.id %>" />
                    <button type="submit">Aposentar Crédito</button>
                </form>
            <% } %>
        </div>
    <% }) %>
<% } %>
```

---

# 💡 5. LÓGICA CLIENT-SIDE — `backend/public/js/wallet.js`

```js
async function initWallet(action, data, contractAddress, abi) {
    if (typeof window.ethereum === 'undefined') {
        document.getElementById('status').innerHTML = '⚠️ Instale o MetaMask!';
        return;
    }

    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);

    document.getElementById('status').innerHTML = '✅ Conectado. Assinando transação...';

    try {
        let tx;

        if (action === 'issue') {
            tx = await contract.issueCredit(
                data.to,
                data.projectId,
                data.location,
                BigInt(data.tonnes)
            );
        } else if (action === 'retire') {
            tx = await contract.retireCredit(BigInt(data.tokenId));
        }

        document.getElementById('status').innerHTML = `⏳ Transação enviada: <a href="https://mumbai.polygonscan.com/tx/${tx.hash}" target="_blank">${tx.hash.substring(0, 10)}...</a>`;
        
        await tx.wait();
        document.getElementById('status').innerHTML += '<br>✅ Transação confirmada! <a href="/">Voltar</a>';
    } catch (err) {
        document.getElementById('status').innerHTML = `❌ Erro: ${err.message}`;
        console.error(err);
    }
}
```

---

# 🚀 6. PASSO A PASSO PARA RODAR TUDO

### 1. Deploy do contrato

```bash
cd carbontrack-express
npx hardhat compile
npx hardhat run scripts/deploy.js --network mumbai
# Copie o endereço e cole em .env
```

### 2. Gerar ABI (opcional — já está em artifacts)

```bash
# Hardhat gera automaticamente em artifacts/
```

### 3. Rodar backend

```bash
cd backend
npm install
npm start
```

> Acesse: `http://localhost:3000`

---

# 🌐 7. DEPLOY PÚBLICO (EX: RENDER.COM)

1. Faça push do projeto para GitHub.
2. Crie um app no [Render.com](https://render.com).
3. Conecte ao repositório.
4. Defina variáveis de ambiente:
   - `PRIVATE_KEY`
   - `POLYGON_MUMBAI_RPC`
   - `CONTRACT_ADDRESS`
5. Deploy!

> ✅ Seu sistema estará acessível publicamente para testes.

---

# 🧪 8. COMO TESTAR PUBLICAMENTE

1. Acesse seu app (ex: `https://carbontrack-brasil.onrender.com`).
2. Conecte o MetaMask na **Polygon Mumbai**.
3. Pegue MATIC grátis em: [https://mumbaifaucet.com](https://mumbaifaucet.com).
4. Emita um crédito (se autorizado) ou aposente um.
5. Verifique a transação no Polygonscan.

