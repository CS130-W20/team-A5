//
//  SaleItemDetailViewController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 3/7/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func post_bid_on_item(saleItem: SaleItem, auth_token: String, num_of_tickets: String, rand_seed: Int) -> Void {
    print("num of tickets \(Double(num_of_tickets)!)")
    print("ticket price \(Double(saleItem.ticket_price)!)")
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(auth_token)"
    ]
    let parameters: [String: Any] = [
        "ticket_count": Int(num_of_tickets),
        "total_cost": Double(num_of_tickets)! * Double(saleItem.ticket_price)!,
        "random_seed": Int(rand_seed)
    ]
    let saleItem_id = saleItem.item_id
    print("sale item id: \(saleItem_id)")
    Alamofire.request(url + "/api/items/bid/\(saleItem_id)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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

func get_seller_name(auth_token: String, user_id: String, completion: @escaping (String) -> Void) {
    let headers: HTTPHeaders = [
           "Authorization": "Bearer \(auth_token)"
       ]
    Alamofire.request(url + "/api/users/\(user_id)", method: .get, encoding: JSONEncoding.default, headers: headers)
        .responseSwiftyJSON { dataResponse in
            print(dataResponse.request)
            if dataResponse.result.isSuccess {
                let message = dataResponse.value!["message"]
                print("message: \(message)")
                if message == "" {
                    let data = dataResponse.value!["data"]
                    print("data: \(data)")
                    let name = data["first_name"].string! + " " + data["last_name"].string!
                    completion(name)
                }
            } else {
                print(dataResponse.error)
            }
    }
}
