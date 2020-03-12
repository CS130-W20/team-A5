const fs = require('fs');
const path = require('path');
const express = require('express');
const compression = require('compression');
const morgan = require('morgan');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const config = require('./config');
const dotenv = require('dotenv').config({path:__dirname+'/.env'})
const cron = require('node-cron');

const {PostgresDB} = require('./db/postgres');
const {UserRepo} = require('./models/user/postgres');
const {UserModel} = require('./models/user');
const {UserController} = require('./controllers/user');
const {ItemRepo} = require('./models/item/postgres');
const {ItemModel} = require('./models/item');
const {ItemController} = require('./controllers/item');
const {AdminController} = require('./controllers/admin')

const {AuthService} = require('./services/auth')
const {RaffleService} = require('./services/raffle')

function start(port) {
	const postgres = PostgresDB(config.database);

	const userRepo = UserRepo(postgres);
	userRepo.setupRepo();

	const userModel = UserModel(userRepo);

	const authService = AuthService(userModel); 
	const userController = UserController(userModel, authService);

	const itemRepo = ItemRepo(postgres);
	itemRepo.setupRepo();
	const itemModel = ItemModel(itemRepo);
	const itemController = ItemController(itemModel, userModel, authService);

	const raffleService = RaffleService(itemModel, userModel);

	const adminController = AdminController(userModel, itemModel, raffleService);


	const app = express();
	app.disable('x-powered-by');
	app.use(compression());
	app.use(morgan('dev'));
	app.use(
		cors({
			origin: ['http://localhost:3000'],
			credentials: true,
		}),
	);
	app.use(cookieParser());
	app.use(bodyParser.json({
		verify: (req, res, buf) => {
			req.rawBody = buf
		}
	}))

	const router = express.Router();
	router.use('/users', userController);
	router.use('/items', itemController);
	router.use('/admin', adminController);

	app.use('/api', router);
	if(process.env.NODE_ENV != 'test'){
		app.listen(port, () => {
			console.log(`Listening on port ${port}`);
		});

		// Cron job so every night at midnight, all raffles past a deadline are ended
		var task = cron.schedule('0 0 * * *', () => {
			raffleService.checkDeadlines()
		}, {
			scheduled: true,
			timezone: "America/Los_Angeles"
		});

		task.start();
	}
	else {
		module.exports = {app, postgres}
	}
}

start(config.port);
