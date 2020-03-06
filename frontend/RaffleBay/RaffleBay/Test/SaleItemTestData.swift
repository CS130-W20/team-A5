//
//  SaleItemTestData.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

struct SaleItemTestData {

    /// posts
    static func saleItems() -> [SaleItem] {
        let saleItem1 = SaleItem(item_name: "Bose QuietComfort 100", seller_id: 1, pic_url: "ticket", item_description: "Headphones.", sale_price: "100", ticket_price: "10", total_tickets: "10")
        let saleItem2 = SaleItem(item_name: "Bose QuietComfort 200", seller_id: 2, pic_url: "bose", item_description: "Headphones 1.", sale_price: "80", ticket_price: "10", total_tickets: "10")
        let saleItem3 = SaleItem(item_name: "Bose QuietComfort 300", seller_id: 2, pic_url: "bose", item_description: "Headphones 2.", sale_price: "120", ticket_price: "10", total_tickets: "10")
        let saleItem4 = SaleItem(item_name: "Bose QuietComfort 400", seller_id: 4, pic_url: "bose", item_description: "Headphones 3.", sale_price: "100", ticket_price: "10", total_tickets: "10")
        let saleItem5 = SaleItem(item_name: "Bose QuietComfort 500", seller_id: 1, pic_url: "bose", item_description: "Headphones. 4", sale_price: "100", ticket_price: "10", total_tickets: "10")
        let saleItem6 = SaleItem(item_name: "Bose QuietComfort 600", seller_id: 1, pic_url: "bose", item_description: "Headphones.", sale_price: "100", ticket_price: "10", total_tickets: "10")



        return  [saleItem1, saleItem2, saleItem3, saleItem4, saleItem5, saleItem6]
    }
}
