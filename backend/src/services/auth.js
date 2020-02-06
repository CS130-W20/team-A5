const AuthService = (userModel) => {
	 
	// Pass in the 'headers' attribute of the request to get the user id of the user 
	// sending the request. Returns [user_id, error] where user_id is an int
	const getLoggedInUserInfo = async (header) => {
		const auth_header = header['authorization']
		if (auth_header == null) {
			return [null, "No Authorization Received"]
		}
		const token = auth_header.slice(7);
		
		[user, err] = await userModel.getUserInfoByToken(token);
		console.log(user)

		if (err) {
			return [null, "Authorization failure -- user not found"]
		}

		return [user, ""]
	};

	return {
    	getLoggedInUserInfo
  };
}

module.exports = {
  AuthService,
};