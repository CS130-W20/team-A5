//
//  ProfileViewController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/20/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func get_user_request(auth_token: String, user: User) -> Void {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(auth_token)"
    ]
    Alamofire.request(url + "/api/users/1", method: .get, encoding: JSONEncoding.default, headers: headers)
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
                user.firstName = data["first_name"].string!
                user.lastName = data["last_name"].string!
                user.pic_url = data["pic_url"].string!
            }
        } else {
            print(dataResponse.error)
        }
    };
    
}
