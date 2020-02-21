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
func login_request(email: String, password: String, authenticationVM: AuthenticationViewModel) -> Int {
    let parameters: [String: Any] = [
        "email": email,
        "password": password
    ]
    var result = 0
    var data_obj = JSON()
    
    print("email: \(email)")
    print("password: \(password)")
    Alamofire.request(url + "/api/users/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    .responseSwiftyJSON { dataResponse in
        print(dataResponse.request)
        if dataResponse.result.isSuccess {
            let data = dataResponse.value!["data"]
            let auth = data["auth_token"]
            print("data: \(data)")
            print("auth: \(auth)")
            data_obj = data
            authenticationVM.auth_token = auth.string!
            let message = dataResponse.value!["message"]
            print("message: \(message)")
            
            result = 1
        } else {
            print(dataResponse.error)
        }
    };
    
    return 1;
}
