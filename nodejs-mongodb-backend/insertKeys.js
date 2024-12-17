// Script to insert keys into the database
const mongoose = require('mongoose');

// MongoDB connection URI
const mongoURI = 'mongodb://localhost:27017/CampusDB';

// Connect to MongoDB
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(async () => {
    const AccessKey = mongoose.model('AccessKey', {
      key: String,
    });

    // Insert keys into the AccessKey collection
    const keys = ['key1', 'key2', 'key3']; // Add your keys here
    await AccessKey.insertMany(keys.map(key => ({ key })));

    console.log('Keys inserted successfully');
    mongoose.disconnect();
  })
  .catch(err => console.error(err));
