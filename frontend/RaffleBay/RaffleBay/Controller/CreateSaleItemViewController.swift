//
//  CreateSaleItemViewController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/20/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func post_sale_item(auth_token: String, saleItem: SaleItem) -> Void {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(auth_token)"
    ]
    let parameters: [String: Any] = [
        "item_name": saleItem.item_name,
        "pic_url": saleItem.pic_url,
        "item_description": saleItem.item_description,
        "tags": "fun",
        "sale_price": Double(saleItem.sale_price),
        "total_tickets": Double(saleItem.total_tickets)
    ]
    Alamofire.request(url + "/api/items/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
