
const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());
const MONGO_URI = process.env.MONGODB_URI || "mongodb+srv://dionamite:Dionamite1!@portalformadores.mob88xm.mongodb.net/flor?retryWrites=true&w=majority&appName=PortalFormadores";
// MongoDB connection using MONGO_URI
mongoose.connect(MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log('Connected to MongoDB');
}).catch(err => {
    console.error('Error connecting to MongoDB', err);
});

// Example route for a generic database operation
app.post('/query', async (req, res) => {
    const { collection, operation, query, data } = req.body;

    try {
        const dbCollection = mongoose.connection.collection(collection);
        let result;

        switch (operation) {
            case 'find':
                result = await dbCollection.find(query).toArray();
                break;
            case 'insert':
                result = await dbCollection.insertOne(data);
                break;
            case 'update':
                result = await dbCollection.updateOne(query, { $set: data });
                break;
            case 'delete':
                result = await dbCollection.deleteOne(query);
                break;
            default:
                return res.status(400).send('Invalid operation');
        }

        res.json(result);
    } catch (error) {
        console.error('Database operation error:', error);
        res.status(500).send('Internal Server Error');
    }
});

const PORT = 5000;
app.listen(PORT, () => {
    console.log(`Central DB Service is running on port ${PORT}`);
});
