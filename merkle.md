# Árvores de Merkle em uma Blockchain

Uma **Árvore de Merkle** é uma estrutura de dados usada em blockchains (como Bitcoin e Ethereum) para organizar e verificar grandes quantidades de transações de forma eficiente. Ela é uma **árvore binária** onde as folhas armazenam hashes (impressões digitais criptográficas) de transações, e os nós superiores combinam esses hashes até formar uma única raiz, chamada **Raiz de Merkle**. Essa raiz é incluída no cabeçalho de um bloco, permitindo verificar rapidamente a integridade e a inclusão de transações sem precisar processar todas elas.

- **Por que é útil?**
  - **Eficiência**: Reduz o espaço necessário para armazenar e verificar transações.
  - **Verificação Rápida**: Permite que nós leves (ex.: carteiras em smartphones) confirmem se uma transação está em um bloco sem baixar toda a blockchain.
  - **Segurança**: Garante que nenhuma transação foi alterada, pois qualquer mudança altera a Raiz de Merkle.

> Para saber quem foi Ralph Merkle, o inventor dessa estrutura vai [aqui](https://pt.wikipedia.org/wiki/Ralph_Merkle)

## 1. Como Funciona uma Árvore de Merkle?

A Árvore de Merkle organiza as transações assim:

1. **Hash das Transações**: Cada transação é transformada em um hash (ex.: usando SHA-256), que é como uma impressão digital única.
2. **Pares de Hashes**: Os hashes são agrupados em pares, e cada par é combinado em um novo hash (hash dos filhos).
3. **Construção da Árvore**: O processo repete, combinando pares de hashes até chegar a um único hash no topo, a **Raiz de Merkle**.
4. **Uso na Blockchain**: A Raiz de Merkle vai para o cabeçalho do bloco. Para verificar se uma transação está no bloco, você só precisa de alguns hashes do caminho até a raiz, não todas as transações.


<img width="1200" height="1200" alt="image" src="https://github.com/user-attachments/assets/09f26b9f-782b-411c-826e-74b1f2260aa5" />

## 2. Benefícios da Árvore de Merkle

- **Eficiência de Espaço**: Em vez de armazenar todas as transações, nós leves guardam apenas a Raiz de Merkle e alguns hashes.
- **Verificação Rápida**: Um cliente SPV (Simplified Payment Verification, como carteiras móveis) verifica transações com poucos dados, ideal para dispositivos com pouca memória.
- **Segurança**: Qualquer alteração em uma transação muda todos os hashes acima, invalidando a Raiz de Merkle e alertando a rede.

## 3. A árvore na Blockchain

Na arquitetura de uma blockchain:

- A Raiz de Merkle está no **cabeçalho do bloco**, junto com o hash do bloco anterior, timestamp e nonce.
- Isso permite que a blockchain seja compacta e eficiente, mesmo com milhares de transações por bloco (ex.: um bloco do Bitcoin pode ter 2.000 transações, mas a Raiz de Merkle é apenas 32 bytes).
- É como um "índice" que resume o conteúdo do bloco, integrado à estrutura descentralizada e imutável da blockchain.

