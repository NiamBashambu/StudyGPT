const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Endpoint in Express.js to forward the request to Python AI model
app.post('/generate-plan', async (req, res) => {
    console.log('Received data:', req.body); // Log incoming data
    try {
        const { assignments } = req.body;

        if (!assignments || !Array.isArray(assignments)) {
            return res.status(400).send('Invalid format: assignments should be an array.');
        }

        // Forward the request to the Python AI model
        const response = await axios.post('http://backend-flask:5000/generate-plan', { assignments });

        // Return the formatted study plans received from the Python AI model
        const formattedStudyPlans = response.data.map(plan => ({
            title: plan.title,
            studyPlan: plan.studyPlan, // Keep it as an array of strings
            dueDate: plan.dueDate,
            type: plan.type
        }));

        res.json(formattedStudyPlans); // Send response back to Swift app
    } catch (error) {
        console.error(error);
        res.status(500).send('Error generating study plan');
    }
});

// Set the port dynamically for Heroku or use 3000 locally
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Express server running on port ${PORT}`);
});