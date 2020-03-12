const {app,postgres} = require('../main'); 
const cleardb = `
TRUNCATE items, bids, users, shipments, payments; 
`;
const addFunds = `
    UPDATE users 
    SET balance = (balance + $2)
    WHERE id = $1
    RETURNING *`;
const adminkey = process.env.ADMIN_AUTH_TOKEN;
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
describe('Choose Winner', () => {
	it('should only choose winners for items awaiting raffle', async () => {
		//create user create item set bid :q
		//
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
		const userData2 = {
			"first_name": "test3",
			"last_name": "User",
			"email": "user3@test.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "123 Address Lane",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const signUpResponse = await request(app).post('/api/users/signup')
			.send(userData)
			.set('Accept', 'applications/json')
			.expect(200); 
		let authid = signUpResponse.body.data.auth_token;
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const create = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.set('Authorization', `Bearer ${authid}`)
			.expect(200);
		const item_id = create.body.data.item_id; 
		const signUpResponse2 = await request(app).post('/api/users/signup')
			.send(userData2)
			.set('Accept', 'applications/json')
			.expect(200); 
		let authid2 = signUpResponse2.body.data.auth_token;
		let userid2 = signUpResponse2.body.data.id;
		const desiredBalance = [userid2,100];
		try {
			const client = await postgres.connect(); 
			const res = await client.query(addFunds, desiredBalance);
			client.release(); 
		} catch(err) {
			throw new Error("Did not add Balance")
		}
		const bidBody = {"ticket_count" : 5, "total_cost" : 25, "random_seed" :210487};
		const response = await request(app).post(`/api/items/bid/${item_id}`)
			.send(bidBody)
			.set('Accept', 'application/json')
			.set('Authorization', `Bearer ${authid2}`)
			.expect(200); 
		const reqRaffle = await request(app).get('/api/admin/select_winners')
			.set('authorization', `Bearer ${adminkey}`)
			.expect(200)
		expect(reqRaffle.body.data).toHaveLength(0); 
	})
	it('should only select one winner', async() => {
		const sellerData = {
			"first_name": "test",
			"last_name": "User",
			"email": "satulurusid98@gmail.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "747 Gayley Avenue",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const buyerData1 = {
			"first_name": "test1",
			"last_name": "User",
			"email": "humanityisspam@gmail.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "747 Gayley Avenue",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		const buyerData2 = {
			"first_name": "test1",
			"last_name": "User",
			"email": "myn4mejeff@yahoo.com",
			"password": "qwerty",
			"pic_url": "<profile_picture_url>",
			"address_1": "747 Gayley Avenue",
			"address_2": "This should be optional",
			"city": "Los Angeles",
			"state": "CA",
			"zip": "90024",
			"phone": "1234567890"
		};
		//SIGNUP SELLER AND CREATE ITEM
		const signUpResponse = await request(app).post('/api/users/signup')
			.send(sellerData)
			.set('Accept', 'applications/json')
			.expect(200); 
		let authid = signUpResponse.body.data.auth_token;
		const itemBody = {"item_name":"testitem", "pic_url":"<test_url>", "item_description" : "description", "tags" : "testing", "sale_price" : 50, "total_tickets":10 };
		const create = await request(app).post('/api/items/create')
			.send(itemBody)
			.set('Accept', 'application/json')
			.set('Authorization', `Bearer ${authid}`)
			.expect(200);
		const item_id = create.body.data.item_id; 
		//SIGNUP BUYER AND CREATE BID 1 
		const signUpResponse2 = await request(app).post('/api/users/signup')
			.send(buyerData1)
			.set('Accept', 'applications/json')
			.expect(200); 
		let authid2 = signUpResponse2.body.data.auth_token;
		let userid2 = signUpResponse2.body.data.id;
		const desiredBalance = [userid2,100];
		try {
			const client = await postgres.connect(); 
			const res = await client.query(addFunds, desiredBalance);
			client.release(); 
		} catch(err) {
			throw new Error("Did not add Balance")
		}
		const bidBody1 = {"ticket_count" : 5, "total_cost" : 25, "random_seed" :210487};
		const response1 = await request(app).post(`/api/items/bid/${item_id}`)
			.send(bidBody1)
			.set('Accept', 'application/json')
			.set('Authorization', `Bearer ${authid2}`)
			.expect(200); 
		//SECOND BID 
		const signUpResponse3 = await request(app).post('/api/users/signup')
			.send(buyerData2)
			.set('Accept', 'applications/json')
			.expect(200); 
		let authid3 = signUpResponse3.body.data.auth_token;
		let userid3 = signUpResponse3.body.data.id;
		const desiredBalance2 = [userid3,100];
		try {
			const client = await postgres.connect(); 
			const res = await client.query(addFunds, desiredBalance2);
			client.release(); 
		} catch(err) {
			throw new Error("Did not add Balance")
		}
		const bidBody2 = {"ticket_count" : 5, "total_cost" : 25, "random_seed" :210487};
		const response2 = await request(app).post(`/api/items/bid/${item_id}`)
			.send(bidBody2)
			.set('Accept', 'application/json')
			.set('Authorization', `Bearer ${authid3}`)
			.expect(200); 
		//SELECT WINNER 
		const reqRaffle = await request(app).get('/api/admin/select_winners')
			.set('Authorization', `Bearer ${adminkey}`)
			.expect(200)
		expect(reqRaffle.body.data).toHaveLength(1);
		//Manually check if received email
	}) 

})
