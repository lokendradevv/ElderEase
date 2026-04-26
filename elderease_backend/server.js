require('dotenv').config();
const express = require('express');
const cors = require('cors');
const multer = require('multer');
const { OpenAI } = require('openai');

const app = express();
const port = process.env.PORT || 3000;

// Set up storage for image uploads
const upload = multer({ dest: 'uploads/' });

// Middleware
app.use(cors());
app.use(express.json());

// Initialize OpenAI
// const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// Routes

// 1. User Management (Stub)
app.post('/api/users', (req, res) => {
  res.status(201).json({ message: 'User created successfully', id: 'user_123' });
});

// 2. Medications (Stub)
app.post('/api/medications', (req, res) => {
  const { userId, name, time, dose } = req.body;
  res.status(201).json({ message: 'Medication scheduled', id: 'med_456' });
});

app.get('/api/medications/:userId', (req, res) => {
  res.status(200).json([
    { id: 'med_456', name: 'Aspirin', time: '08:00', dose: '1 pill', status: 'pending' },
    { id: 'med_789', name: 'Vitamin C', time: '12:00', dose: '1 pill', status: 'pending' }
  ]);
});

// 3. AI Verification (Stub)
app.post('/api/verify', upload.single('image'), async (req, res) => {
  try {
    // In actual implementation, we read req.file and send it to OpenAI Vision.
    // For prototype, we mock success if file is present.
    if (!req.file) {
      return res.status(400).json({ error: 'No image uploaded' });
    }

    /*
    const response = await openai.chat.completions.create({
      model: "gpt-4-vision-preview",
      messages: [
        {
          role: "user",
          content: [
            { type: "text", text: "Is this Aspirin?" },
            { type: "image_url", image_url: { url: `data:image/jpeg;base64,...` } }
          ],
        },
      ],
    });
    */

    // Mock Response
    res.status(200).json({ 
      valid: true, 
      confidence: 0.95,
      message: "Valid medication detected." 
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Verification failed' });
  }
});

// 4. LINE Webhook (Stub)
app.post('/webhook/line', (req, res) => {
  console.log('LINE Webhook Received:', req.body);
  res.status(200).send('OK');
});

// Start Server
app.listen(port, () => {
  console.log(`ElderEase Backend listening on port ${port}`);
});
