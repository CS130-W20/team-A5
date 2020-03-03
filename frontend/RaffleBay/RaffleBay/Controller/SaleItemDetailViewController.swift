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
func post_bid_on_item(saleItem: SaleItem) -> Void {
//    let headers: HTTPHeaders = [
//        "Authorization": "Bearer \(auth_token)"
//    ]
    let parameters: [String: Any] = [
        "item_name": saleItem.item_name,
        "seller_id": "1",
        "pic_url": "<url>",
        "item_description": saleItem.item_description,
        "tags": "fun",
        "sale_price": saleItem.sale_price,
        "ticket_price": saleItem.ticket_price,
        "total_tickets": saleItem.total_tickets,
        "bids": "4",
        "is_ended": "False",
        "deadline": "now",
        "status": "cur_status",
        "current_ledger": "0"
    ]
    Alamofire.request(url + "/api/items/postitem", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
