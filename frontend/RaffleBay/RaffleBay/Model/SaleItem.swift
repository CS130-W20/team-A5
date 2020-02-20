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
    @Published var sale_price: Int = 0
    @Published var ticket_price: Int = 0
    @Published var total_tickets: Int = 0
    @Published var is_ended: Bool = true
    
    init(item_name: String, pic_url: String) {
        self.item_name = item_name
        self.pic_url = pic_url
    }
}
