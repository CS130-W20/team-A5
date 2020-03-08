//
//  SaleItemTableView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 3/7/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import Alamofire_SwiftyJSON
import Alamofire
import SwiftyJSON
func get_all_items(completion: @escaping ([SaleItem]) -> Void) {
    var saleItems: [SaleItem] = []
    Alamofire.request(url + "/api/items/feed", method: .get, encoding: JSONEncoding.default)
    .responseSwiftyJSON { dataResponse in
        print(dataResponse.request)
        if dataResponse.result.isSuccess {
            let message = dataResponse.value!["message"]
            print("message: \(message)")
            if message == "" {
                let data = dataResponse.value!["data"]
                print("data: \(data)")
                if let items_selling = data.array { print(items_selling)
                    for item in items_selling {
                        print(item["item_name"].string!)
//                        print(item["seller_id"].int!)
                        print(item["pic_url"].string!)
                        print(item["item_description"].string!)
                        print(String(item["sale_price"].double!))
                        print(String(item["ticket_price"].double!))
                        print(String(item["total_tickets"].int!))
                        print(String(item["item_id"].int!))
//                        print(item["created_at"].string!)
                        let sale_item = SaleItem(item_name: item["item_name"].string!, item_id: item["item_id"].int!, seller_id: /*item["seller_id"].int! ?? */0,pic_url: item["pic_url"].string!, item_description: item["item_description"].string!,sale_price: String(item["sale_price"].double!),ticket_price: String(item["ticket_price"].double!),  total_tickets: String(item["total_tickets"].int!), created_at: /*item["created_at"].string! ??*/ "" )
                        saleItems.append(sale_item)
                        print(sale_item.item_name)
                    }
                }
                completion(saleItems)
            }
        } else {
            print(dataResponse.error)
        }
    };
}
