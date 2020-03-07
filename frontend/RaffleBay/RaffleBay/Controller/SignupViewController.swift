//
//  SignupViewController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 3/7/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func post_signup(newUser: User) -> Void {
    let parameters: [String: Any] = [
        "first_name": newUser.firstName,
        "last_name": newUser.lastName,
        "email": newUser.email,
        "password": newUser.password,
        "pic_url": newUser.pic_url,
        "address_1": newUser.streetAddress,
        "address_2": "<user_address_line_two>",
        "city": newUser.city,
        "state": newUser.state,
        "zip": newUser.zipcode,
        "phone": newUser.phoneNumber
    ]
    Alamofire.request(url + "/api/users/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    .responseSwiftyJSON { dataResponse in
        print(dataResponse.request)
        if dataResponse.result.isSuccess {
            let message = dataResponse.value!["message"]
            print("message: \(message)")
            if message == "" {
                let data = dataResponse.value!["data"]
                print("data: \(data)")
            }
        } else {
            print(dataResponse.error)
        }
    };

}
