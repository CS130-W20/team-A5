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
    var response = "";
    Alamofire.request("https://localhost:31337/api/users/login", method: .post)
    .responseSwiftyJSON { dataResponse in
                print(dataResponse.request)
                print(dataResponse.response)
                print(dataResponse.error)
                print(dataResponse.value)
        if ((dataResponse.value?["first_name"].string) != nil) {
            response = dataResponse.value?["message"].string ?? "error";
        }
    };
    return 1;
}

//func login_request_response(email: String, password: String) -> SaleItemTableView {
//    if login_request(email: email, password: password) == "error" {
//        print("YAAASSSSS")
//
//        return SaleItemTableView()
//    }
//    print("NOOOOOOOOOO")
//    return SaleItemTableView()
//}
