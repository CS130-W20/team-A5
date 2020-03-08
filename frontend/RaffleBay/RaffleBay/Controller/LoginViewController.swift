//
//  LoginViewController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/13/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func login_request(email: String, password: String, authenticationVM: AuthenticationViewModel, user: User, completion: @escaping (Bool) -> Void) {
    let parameters: [String: Any] = [
        "email": email,
        "password": password
    ]
    var result = false
    
    print("email: \(email)")
    print("password: \(password)")
    Alamofire.request(url + "/api/users/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    .responseSwiftyJSON { dataResponse in
        print(dataResponse.request)
        if dataResponse.result.isSuccess {
            let message = dataResponse.value!["message"]
            print("message: \(message)")
            if message == "" {
                let data = dataResponse.value!["data"]
                let auth = data["auth_token"]
                print("data: \(data)")
                print("auth: \(auth)")
                authenticationVM.auth_token = auth.string!
                user.firstName = data["first_name"].string!
                user.lastName = data["last_name"].string!
                user.pic_url = data["pic_url"].string!
                user.account_balance = "0"
                result = true
                completion(result)
            } else {
                completion(result)
            }
        } else {
            print(dataResponse.error)
            completion(result)
        }
    };
    
}
