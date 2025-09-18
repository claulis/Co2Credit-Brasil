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
