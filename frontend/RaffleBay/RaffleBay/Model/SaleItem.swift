//
//  SaleItem.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

struct SaleItem: Identifiable {
    //TODO: Fill out based on class diagram
    // unique product id
    var id: String = UUID().uuidString
    
    // name of product
    let name: String
    
    // image of product
    let image: String
    
    init(name: String, image: String) {
           self.name = name
           self.image = image
       }
}
