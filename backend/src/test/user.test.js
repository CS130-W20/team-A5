const {app,postgres} = require('../main'); 
const cleardb = `
TRUNCATE items, bids, users, shipments, payments; 
`;
beforeEach(async() => {
	try{
		const client = await postgres.connect(); 
		await client.query(cleardb); 
		client.release(); 
		return null; 
	} catch(err) {
		return err; 
	}
});
const request = require('supertest');


describe('Create User', () => {
	it('should create a user when given proper data', async () => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(response.body.data.email).toEqual(userData.email); 
	})
	it('should allow for null optional fields', async () => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(response.body.data.email).toEqual(userData.email); 
	})
	it('should reject null required fields', async () => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(400); 
	})
	it('should dissallow two users with the exact same data', async () => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response0 = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(response.body.data.email).toEqual(userData.email); 
		const response1 = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(400); 
	})
	it('should dissallow users with an empty password', async () => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response1 = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(400); 

	})
})
describe('login', () => {
	it('should properly authenticate a valid user', async () => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(response.body.data.email).toEqual(userData.email); 
		const authenticating = await request(app).post('/api/users/login')
			.send({"email":"user@test.com","password":"qwerty"})
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(authenticating.body.data.email).toEqual(userData.email); 

	})
	it('should not allow a nonexistant user', async() => {
		const authenticating = await request(app).post('/api/users/login')
			.send({"email":"user@test.com","password":"qwerty"})
			.set('Accept', 'applications/json')
			.expect(400); 
	})
	it('should not allow a user currently logged in', async() => {
		const userData = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const response = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(response.body.data.email).toEqual(userData.email); 
		const authenticating = await request(app).post('/api/users/login')
			.send({"email":"user@test.com","password":"qwerty"})
			.set('Accept', 'applications/json')
			.expect(200); 
		expect(authenticating.body.data.email).toEqual(userData.email); 
		const second_auth = await request(app).post('/api/users/login')
			.send({"email":"user@test.com","password":"qwerty"})
			.set('Accept', 'applications/json')
			.expect(400); 
	})
})
describe('get info of other users', () => {
	it('should not detail any private data of other users', async() => {
		const user1Data = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const user2Data = {
			"first_name": "test2",
			"last_name": "User2",
			"email": "user2@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "124 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234576890"
		};
		const user1 = await request(app).post('/api/users/signup')
			.send(user1Data)
			.set('Accept', 'applications/json')
			.expect(200); 
		const user2 = await request(app).post('/api/users/signup')
			.send(user2Data)
			.set('Accept', 'applications/json')
			.expect(200); 
		const id2 = user2.body.data.id;
		console.log(id2)
		const login = await request(app).post('/api/users/login')
			.send({"email":"user@test.com","password":"qwerty"})
			.expect(200)
		let authid = login.body.data.auth_token;
		const response = await request(app).get(`/api/users/${id2}`)
			.set('Accept', 'applications/json')
			.set('Authorization', `Bearer ${authid}`)
			.expect(200); 
		console.log(response.body.message);
		expect(response.body.data.balance).toBeUndefined();
	})
	it('should detail private data if user is the same as logged in user', async() => {
		const user1Data = {
			"first_name": "test",
			"last_name": "User",
			"email": "user@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const user1 = await request(app).post('/api/users/signup')
			.send(user1Data)
			.set('Accept', 'applications/json')
			.expect(200); 
		const id2 = user1.body.data.id
		const login = await request(app).post('/api/users/login')
			.send({"email":"user@test.com","password":"qwerty"})
			.expect(200)
		let authid = login.body.data.auth_token;
		const response = await request(app).get(`/api/users/${id2}`)
			.send({"email":"user@test.com","password":"qwerty"})
			.set('Accept', 'applications/json')
			.set('Authorization', `Bearer ${authid}`)
			.expect(200); 
		expect(response.body.data.balance).toBeDefined();

	})
})
