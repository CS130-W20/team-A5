//
//  SellingItem.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/29/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

class BuyingItem: Identifiable, ObservableObject {
    let id = UUID()
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
    @Published var created_at: String = ""
    init(item_name: String, pic_url: String, sale_price: String, created_at: String, tickets_sold: String, total_tickets: String) {
        self.item_name = item_name
        self.pic_url = pic_url
        self.sale_price = sale_price
        self.created_at = created_at
        self.tickets_sold = tickets_sold
        self.total_tickets = total_tickets
    }
}



