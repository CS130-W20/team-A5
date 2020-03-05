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
    Alamofire.request(url + "/api/users/me", method: .get, encoding: JSONEncoding.default, headers: headers)
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
                user.pic_url = data["picture_url"].string!
                user.account_balance = String(data["balance"].int!)
            }
        } else {
            print(dataResponse.error)
        }
    };
    
}
func get_items_selling_and_bidding(auth_token: String, completion: @escaping (([SellingItem], [BuyingItem])) -> Void) {
    var selling: [SellingItem] = []
    var buying: [BuyingItem] = []
    let headers: HTTPHeaders = [
           "Authorization": "Bearer \(auth_token)"
       ]
       Alamofire.request(url + "/api/items/me", method: .get, encoding: JSONEncoding.default, headers: headers)
       .responseSwiftyJSON { dataResponse in
           print(dataResponse.request)
           if dataResponse.result.isSuccess {
               let message = dataResponse.value!["message"]
               print("message: \(message)")
               if message == "" {
                let data = dataResponse.value!["data"]
                //                   let auth = data["auth_token"]
                                   print("data: \(data)")
                if let items_selling = data["items_selling"].array { print(items_selling)
                    for item in items_selling {
                        let sellingItem = SellingItem(item_name: item["item_name"].string!, pic_url: item["pic_url"].string!, sale_price: String(item["sale_price"].int!), created_at: item["created_at"].string!, tickets_sold: String(item["tickets_sold"].int!), total_tickets: String(item["total_tickets"].int!) )
                        selling.append(sellingItem)
                        print(sellingItem.item_name)
                    }
                }
                completion((selling, buying))
               }
           } else {
               print(dataResponse.error)
           }
       };
}
