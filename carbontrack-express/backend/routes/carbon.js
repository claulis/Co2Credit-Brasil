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
