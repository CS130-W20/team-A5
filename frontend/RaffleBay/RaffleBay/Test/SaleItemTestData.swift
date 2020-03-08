//
//  SaleItemTestData.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//
import Foundation



struct SaleItemTestData {
    static func returnStringDate() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return(dateFormatter.string(from: today))
    }
    
    
    
    // posts
    static func saleItems() -> [SaleItem] {
//        let saleItem1 = SaleItem(item_name: "Bose QuietComfort 100", seller_id: 1, pic_url: "ticket", item_description: "Headphones.", sale_price: "100", ticket_price: "10", total_tickets: "10", created_at: returnStringDate())
//        let saleItem2 = SaleItem(item_name: "Bose QuietComfort 200", seller_id: 2, pic_url: "bose", item_description: "Headphones 1.", sale_price: "80", ticket_price: "10", total_tickets: "10", created_at: returnStringDate())
//        let saleItem3 = SaleItem(item_name: "Bose QuietComfort 300", seller_id: 2, pic_url: "bose", item_description: "Headphones 2.", sale_price: "120", ticket_price: "10", total_tickets: "10", created_at: returnStringDate())
//        let saleItem4 = SaleItem(item_name: "Bose QuietComfort 400", seller_id: 4, pic_url: "bose", item_description: "Headphones 3.", sale_price: "100", ticket_price: "10", total_tickets: "10", created_at: returnStringDate())
//        let saleItem5 = SaleItem(item_name: "Bose QuietComfort 500", seller_id: 1, pic_url: "bose", item_description: "Headphones. 4", sale_price: "100", ticket_price: "10", total_tickets: "10", created_at: returnStringDate())
//        let saleItem6 = SaleItem(item_name: "Bose QuietComfort 600", seller_id: 1, pic_url: "bose", item_description: "Headphones.", sale_price: "100", ticket_price: "10", total_tickets: "10", created_at: returnStringDate())



        return  []
    }
}
