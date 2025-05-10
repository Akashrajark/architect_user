// lib/stability_image_server.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { generateImage } = require('./stability_image_generate');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.post('/generate-image', async (req, res) => {
  const { prompt, apiKey, options } = req.body;
  if (!prompt || !apiKey) {
    return res.status(400).json({ error: 'Missing prompt or apiKey' });
  }
  const result = await generateImage(prompt, apiKey, options || {});
  if (result.status && result.status !== 200) {
    return res.status(result.status).json(result.data);
  }
  res.json(result);
});

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Stability Image Server running on port ${PORT}`);
});