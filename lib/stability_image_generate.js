// stability_image_generate.js
// Node.js module to call Stability AI v2beta/stable-image/generate/ultra API
// Usage: require and call generateImage(prompt, apiKey, options)

const axios = require('axios');

/**
 * Generate an image using Stability AI's v2beta/stable-image/generate/ultra endpoint.
 * @param {string} prompt - The image prompt.
 * @param {string} apiKey - Your Stability AI API key.
 * @param {object} [options] - Optional parameters (see API docs).
 * @returns {Promise<object>} - The API response or error details.
 */
async function generateImage(prompt, apiKey, options = {}) {
  const url = 'https://api.stability.ai/v2beta/stable-image/generate/ultra';
  try {
    const response = await axios.post(
      url,
      {
        prompt,
        ...options
      },
      {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        timeout: 60000
      }
    );
    return response.data;
  } catch (error) {
    if (error.response) {
      // API responded with error status
      return {
        status: error.response.status,
        data: error.response.data,
        headers: error.response.headers
      };
    } else {
      // Network or other error
      return { error: error.message };
    }
  }
}

// Example usage (uncomment to test directly):
// (async () => {
//   const result = await generateImage('A futuristic cityscape at sunset', 'YOUR_API_KEY');
//   console.log(result);
// })();

module.exports = { generateImage };