const express = require('express');
const cors = require('cors');
const migrationService = require('./service/migrationService');

const cookieParser = require('cookie-parser');

const app = express();

// Configurable CORS
const allowedOrigins = process.env.CORS_ALLOWED_ORIGINS ? process.env.CORS_ALLOWED_ORIGINS.split(',') : '*';
app.use(cors({
	origin: allowedOrigins,
	methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
	allowedHeaders: ['Content-Type', 'Authorization'],
	credentials: true
}));

app.use(express.json());
app.use(cookieParser());

app.get('/health', (req, res) => {
	res.status(200).send('OK');
});

// Routes
app.use('/auth', require('./route/authRoute'));
app.use('/users', require('./route/usersRoute'));
app.use('/', require('./route/postsRoute'));
app.use(function (error, req, res, next) {
	if (error.message === 'Post already exists') {
		return res.status(409).send(error.message);
	}
	if (error.message === 'Post not found') {
		return res.status(404).send(error.message);
	}
	res.status(500).send(error.message);
});

// Start Server strictly after DB connection and migration
migrationService.runMigrations().then(() => {
	app.listen(3000, () => {
		console.log('Server running on port 3000');
	});
}).catch(err => {
	console.error('Failed to run migrations', err);
	process.exit(1);
});
