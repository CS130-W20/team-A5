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
describe('Choose Winner', () => {
	it('should only choose winners for items awaiting raffle', async () => {
	
	})
	it('should only select one winner', async() => {
	}) 

})
