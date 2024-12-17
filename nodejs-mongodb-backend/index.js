const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// Create an Express app
const app = express();

// Increase payload limit
app.use(bodyParser.json({ limit: '100mb' }));

// Body parser middleware
app.use(bodyParser.json());

// MongoDB connection URI
const mongoURI = 'mongodb://localhost:27017/CampusDB';

// Connect to MongoDB
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Define a mongoose model for the Activity schema
const Activity = mongoose.model('Activity', {
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  user: String,
  content: String,
  picture: String, // URL xor path to picture
  timestamp: { type: Date, default: Date.now },
  userProfilePicture: { type: String, default: null }
});

// Define a mongoose model for the User schema
const User = mongoose.model('User', {
  username: String,
  password: String,
  bio: String,
  profilePicture: String,
  activities: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Activity' }]
});

// Define a mongoose model for the AccessKey schema
const AccessKey = mongoose.model('AccessKey', {
  key: String,
});

// Hash function for password security
async function hashPassword(password) {
    try {
        // Generate a salt
        const saltRounds = 10;
        const salt = await bcrypt.genSalt(saltRounds);
        
        // Hash the password with the salt
        const hashedPassword = await bcrypt.hash(password, salt);
        
        return hashedPassword;
    } catch (error) {
        console.error('Error hashing password:', error);
        throw error;
    }
}

// Route to handle user login
app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Find the user by username
    const user = await User.findOne({ username });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Compare the provided password with the hashed password
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Return user data (excluding password)
    res.json({
      id: user._id,
      username: user.username,
      bio: user.bio,
      profilePicture: user.profilePicture,
      activities: user.activities
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Route to handle user registration
app.post('/api/register', async (req, res) => {
  const { key, username, password } = req.body;

  // Check if the provided key is valid (you should implement this logic)
  const isValidKey = await isValidAccessKey(key);

  if (!isValidKey) {
    return res.status(403).json({ message: 'Invalid access key' });
  }

  try {
    // Hash the password
    const hashedPassword = await hashPassword(password);
    const newUser = new User({ username, password: hashedPassword });
    await newUser.save();
    res.status(201).json(newUser);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

app.get('/api/register', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

async function isValidAccessKey(key) {
  try {
    // Check if the provided key exists in the AccessKey collection
    const existingKey = await AccessKey.findOne({ key });
    return existingKey !== null;
  } catch (err) {
    console.error(err);
    return false;
  }
}

app.get('/api/accesskeys', async (req, res) => {
  try {
    // Retrieve all access keys from the AccessKey collection
    const accessKeys = await AccessKey.find();
    res.json(accessKeys);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Get all activities
app.get('/api/activities', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const activities = await Activity.find()
	.sort({ timestamp: -1 })
	.skip(skip)
	.limit(limit);

    res.json(activities);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Get activities for a specific user
app.get('/api/users/:userId/activities', async (req, res) => {
  const { userId } = req.params;

  try {
    const activities = await Activity.find({ userId })
      .sort({ timestamp: -1 }); // Sort activities by timestamp descending

    res.json(activities);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Create a new activity
app.post('/api/activities', async (req, res) => {
  const { userId, user, content, picture, timestamp } = req.body;

  try {
    const timestamp = new Date().toUTCString();

    const userWithProfilePicture = await User.findById(userId).select('profilePicture');
    let userProfilePicture = '';
    if (userWithProfilePicture && userWithProfilePicture.profilePicture) {
         userProfilePicture = userWithProfilePicture.profilePicture;
    } else {
         userProfilePicture = 'https://example.com/white-circle.png';
    }

    const newActivity = new Activity({ userId, user, content, picture, userProfilePicture, timestamp });
    await newActivity.save();
    await User.findByIdAndUpdate(userId, { $push: { activities: newActivity._id } });

    res.status(201).json(newActivity);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

app.delete('/api/activities/:id', async (req, res) => {
  const { id } = req.params;

  try {
    // Find the activity by ID and delete it
    const deletedActivity = await Activity.findByIdAndDelete(id);
    
    if (!deletedActivity) {
      return res.status(404).json({ message: 'Activity not found' });
    }

    await User.findByIdAndUpdate(deletedActivity.userId, { $pull: { activities: id } });

    res.json({ message: 'Activity deleted successfully', deletedActivity });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Route to update user bio
app.put('/api/users/:userId/bio', async (req, res) => {
  const { userId } = req.params;
  const { bio } = req.body;

  try {
    const updatedUser = await User.findByIdAndUpdate(userId, { bio }, { new: true });
    res.json(updatedUser);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Route to fetch user profile picture
app.get('/api/users/:userId/profile-picture', async (req, res) => {
  const { userId } = req.params;

  try {
    // Find the user by userId
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Retrieve profile picture URL from user document
    const profilePicture = user.profilePicture;

    if (!profilePicture) {
      return res.status(404).json({ message: 'Profile picture not found for this user' });
    }

    // Return the profile picture URL in the response
    res.json({ profilePicture });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Route to update user profile picture
app.put('/api/users/:userId/profile-picture', async (req, res) => {
  const { userId } = req.params;
  const { profilePicture } = req.body;

  try {
    const updatedUser = await User.findByIdAndUpdate(userId, { profilePicture }, { new: true });

    // Find activities of this user
    const activities = await Activity.find({ userId });

    const updatedActivities = await Promise.all(activities.map(async (activity) => {
	activity.userProfilePicture = profilePicture;
	return await activity.save();
    }));

    res.json(updatedUser);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Route to fetch user bio
app.get('/api/users/:userId/bio', async (req, res) => {
  const { userId } = req.params;

  try {
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ bio: user.bio });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
