//
//  SaleItem.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

class SaleItem: ObservableObject {
    
    @Published var item_id: Int = 0
    @Published var item_name: String = ""
    @Published var seller_id: Int = 0
    @Published var pic_url: String  = ""
    @Published var item_description: String = ""
    @Published var tags: String = ""
    @Published var sale_price: String = ""
    @Published var ticket_price: String = ""
    @Published var total_tickets: String = ""
    @Published var tickets_sold: String = ""
    @Published var is_ended: Bool = true
    @Published var created_at: String = ""
    
    init(item_name: String, item_id: Int, seller_id: Int, pic_url: String, item_description: String, sale_price: String, ticket_price: String, total_tickets: String, tickets_sold: String, created_at: String) {
        self.item_name = item_name
        self.item_id = item_id
        self.seller_id = seller_id
        self.pic_url = pic_url
        self.item_description = item_description
        self.sale_price = sale_price
        self.ticket_price = ticket_price
        self.total_tickets = total_tickets
        self.tickets_sold = tickets_sold
        self.created_at = created_at
    }
}
