/**
 * A standalone service to help with user and request authentication
 * @constructor
 * 
 * @param  {UserModel} userModel - The UserModel that provides access to the User Database
 * @return {AuthService} - Returns an instance of AuthService
 */
const AuthService = (userModel) => {
	 
	/**
	 * Uses the Authorization header to find the logged in user, returning an error if the token is invalid
	 * 
	 * @param  {Object} header - The request header sent with the request, as a Javascript object
	 * @return {Array<{User, String}>} - Returns the information for the logged-in user as defined by the given auth_token
	 */
	const getLoggedInUserInfo = async (header) => {
		const auth_header = header['authorization']
		if (auth_header == null) {
			return [null, "No Authorization Received"]
		}
		const token = auth_header.slice(7);
		
		[user, err] = await userModel.getUserInfoByToken(token);

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