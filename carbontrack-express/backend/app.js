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
