////
////  AddFundsViewController.swift
////  RaffleBay
////
////  Created by Meera Rachamallu on 3/7/20.
////  Copyright © 2020 Meera Rachamallu. All rights reserved.
////
//
import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func post_add_funds(auth_token: String, fund_amt: Double, completion: @escaping (JSON) -> Void) {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(auth_token)"
    ]
    let parameters: [String: Any] = [
        "amount": fund_amt
    ]
    Alamofire.request(deployed_url + "/api/users/funds/start", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    .responseSwiftyJSON { dataResponse in
        print(dataResponse.request)
        if dataResponse.result.isSuccess {
            let message = dataResponse.value!["message"]
            print("message: \(message)")
            if message == "" {
                let data = dataResponse.value!["data"]
                print("data: \(data)")
                completion(data)
            }
        } else {
            print(dataResponse.error)
        }
    };

}
