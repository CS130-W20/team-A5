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
func login_request(email: String, password: String) -> Int {
    var result = 0
    Alamofire.request("http://localhost:31337/api/users/login", method: .post, parameters: ["email":email, "password":password])
    .responseSwiftyJSON { dataResponse in
        if dataResponse.result.isSuccess {
            let data = dataResponse.value!["data"].string
            print(data)
            let message = dataResponse.value!["message"].string
            print(message)
            result = 1
        } else {
            print(dataResponse.error)
        }
    };
    return result;
}
