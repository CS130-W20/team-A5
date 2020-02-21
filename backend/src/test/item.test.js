const request = require('supertest');
const app = require('../main'); 

describe('createItem', () => {
	it('should test that true === true',  () => {
    expect(true).toBe(true)
	})
	it('should create a item with proper parameters', async () => {
		//TODO incomplete, must first login with user id 
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const response = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.expect(200);
		expect(response.data.item_name).toEqual("testitem"); 
	})
	it('should fail on item with no body', async() => {
		//TODO must first login 
		const response = await request(app).post('/api/items/create')
			.send(null)
			.expect(400);
		expect(response.message).toEqual("Malformed Request"); 
	})
	it('should fail on missing data', async() => {
		//TODO must first login
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		await request(app).post('/api/items/create')
			.send(itemBody)
			.expect(400);  
	})
	it('should reject items with the exact same data', async () => {
		//TODO must first login
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const response = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.expect(200);
		const response1 = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.expect(400);
	})
})
describe('Create Bid', () => {
	it('should properly create a bid given the correct parameters', () => {
		//TODO login
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const create = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.expect(200);
		const item_id = create.item_id; 
		const response = await request(app).post('/api/items/bid/item_id')
			.send({"ticket_count":1, "total_cost":5})
			.set('Accept', 'application/json')
			.expect(200); 
		expect(response.data.total_cost).toEqual(5); 
	})
	it('should refuse to create a bid for a user not logged in', () => {
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const create = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.expect(200);
		const item_id = create.item_id; 
		const response = await request(app).post('/api/items/bid/item_id')
			.send({"ticket_count":1, "total_cost":5})
			.set('Accept', 'application/json')
			.expect(400); 
	})
	it('should refuse to create a bid for a user with insufficient funds', () => {
		//TODO: Login with user with 0 funds
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const create = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.expect(200);
		const item_id = create.item_id; 
		const response = await request(app).post('/api/items/bid/item_id')
			.send({"ticket_count":1, "total_cost":5})
			.set('Accept', 'application/json')
			.expect(400); 
		expect(response.message).toEqual("Insufficient Funds"); 

	})
})

