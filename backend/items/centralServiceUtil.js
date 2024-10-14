
const axios = require('axios');

// Function to communicate with the central database service
async function communicateWithCentralService(operation, collection, query = {}, data = {}) {
    try {
        const response = await axios.post('http://localhost:5000/query', {
            operation,
            collection,
            query,
            data
        });
        return response.data;
    } catch (error) {
        console.error('Error communicating with central service:', error);
        throw error;
    }
}

module.exports = communicateWithCentralService;
