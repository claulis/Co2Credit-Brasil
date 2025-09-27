# Árvores de Merkle em uma Blockchain

Uma **Árvore de Merkle** é uma estrutura de dados usada em blockchains (como Bitcoin e Ethereum) para organizar e verificar grandes quantidades de transações de forma eficiente. Ela é uma **árvore binária** onde as folhas armazenam hashes (impressões digitais criptográficas) de transações, e os nós superiores combinam esses hashes até formar uma única raiz, chamada **Raiz de Merkle**. Essa raiz é incluída no cabeçalho de um bloco, permitindo verificar rapidamente a integridade e a inclusão de transações sem precisar processar todas elas.

- **Por que é útil?**
  - **Eficiência**: Reduz o espaço necessário para armazenar e verificar transações.
  - **Verificação Rápida**: Permite que nós leves (ex.: carteiras em smartphones) confirmem se uma transação está em um bloco sem baixar toda a blockchain.
  - **Segurança**: Garante que nenhuma transação foi alterada, pois qualquer mudança altera a Raiz de Merkle.

> Para saber quem foi Ralph Merkle, o inventor dessa estrutura vai [aqui](https://pt.wikipedia.org/wiki/Ralph_Merkle)

## 1. Como Funciona uma Árvore de Merkle?

Imagine um bloco com 4 transações (Tx1, Tx2, Tx3, Tx4). A Árvore de Merkle organiza essas transações assim:

1. **Hash das Transações**: Cada transação é transformada em um hash (ex.: usando SHA-256), que é como uma impressão digital única.
2. **Pares de Hashes**: Os hashes são agrupados em pares, e cada par é combinado em um novo hash (hash dos filhos).
3. **Construção da Árvore**: O processo repete, combinando pares de hashes até chegar a um único hash no topo, a **Raiz de Merkle**.
4. **Uso na Blockchain**: A Raiz de Merkle vai para o cabeçalho do bloco. Para verificar se uma transação está no bloco, você só precisa de alguns hashes do caminho até a raiz, não todas as transações.

- **Exemplo Prático**: Se você quer provar que Tx1 está no bloco, fornece o hash de Tx1, o hash de Tx2 (seu par), e os hashes intermediários até a raiz. Um nó leve recalcula a raiz e compara com a do bloco – se coincidir, Tx1 está confirmada.

```mermaid
graph TD
    A[Raiz de Merkle<br>Hash: H1234] --> B[Hash 12<br>H(Tx1 + Tx2)]
    A --> C[Hash 34<br>H(Tx3 + Tx4)]
    B --> D[Hash Tx1<br>H(Tx1)]
    B --> E[Hash Tx2<br>H(Tx2)]
    C --> F[Hash Tx3<br>H(Tx3)]
    C --> G[Hash Tx4<br>H(Tx4)]
    D --> H[Transação 1<br>Ex.: Alice envia 1 BTC]
    E --> I[Transação 2<br>Ex.: Bob envia 0.5 BTC]
    F --> J[Transação 3<br>Ex.: Carol envia 2 BTC]
    G --> K[Transação 4<br>Ex.: Dave envia 0.1 BTC]
```


- **Folhas (H a K)**: Cada transação (Tx1 a Tx4) é convertida em um hash (Hash Tx1 a Hash Tx4) usando uma função criptográfica como SHA-256.
- **Nós Intermediários (B e C)**: Pares de hashes de transações são combinados (ex.: Hash Tx1 + Hash Tx2 = Hash 12) usando a mesma função de hash.
- **Raiz de Merkle (A)**: O hash final (H1234) combina Hash 12 e Hash 34, resumindo todas as transações do bloco.
- **Fluxo**: As setas apontam de cima para baixo, mas a construção é de baixo para cima (das transações à raiz), como em uma estrutura de dados de árvore binária.
- **Uso Prático**: Para verificar Tx1, você precisa de Hash Tx1, Hash Tx2, Hash 34 e da Raiz de Merkle. Recalculando o caminho (Hash 12 = H(Hash Tx1 + Hash Tx2), então H1234 = H(Hash 12 + Hash 34)), confirma-se a inclusão de Tx1.

## 2. Benefícios da Árvore de Merkle

- **Eficiência de Espaço**: Em vez de armazenar todas as transações, nós leves guardam apenas a Raiz de Merkle e alguns hashes.
- **Verificação Rápida**: Um cliente SPV (Simplified Payment Verification, como carteiras móveis) verifica transações com poucos dados, ideal para dispositivos com pouca memória.
- **Segurança**: Qualquer alteração em uma transação muda todos os hashes acima, invalidando a Raiz de Merkle e alertando a rede.

## 3. A árvore na Blockchain

Na arquitetura de uma blockchain:

- A Raiz de Merkle está no **cabeçalho do bloco**, junto com o hash do bloco anterior, timestamp e nonce.
- Isso permite que a blockchain seja compacta e eficiente, mesmo com milhares de transações por bloco (ex.: um bloco do Bitcoin pode ter 2.000 transações, mas a Raiz de Merkle é apenas 32 bytes).
- É como um "índice" que resume o conteúdo do bloco, integrado à estrutura descentralizada e imutável da blockchain.

