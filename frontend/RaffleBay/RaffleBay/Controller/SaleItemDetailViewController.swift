//
//  SaleItemDetailViewController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 3/1/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func post_bid_on_item(saleItem: SaleItem, auth_token: String, num_of_tickets: String) -> Void {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(auth_token)"
    ]
    let parameters: [String: Any] = [
        "ticket_count": Int(num_of_tickets),
        "total_cost": Int(num_of_tickets)! * Int(saleItem.ticket_price)!
    ]
    Alamofire.request(url + "/api/items/bid/1", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
