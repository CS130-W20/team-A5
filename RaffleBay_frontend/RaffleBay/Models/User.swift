//
//  User.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 1/30/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    //TODO: Fill out based on class diagram
    // unique product id
    var id: String
    
    // name of product
    let name: String
    
    // image of product
    let image: String
    
    // price of ticket
    let price: double_t
    
    // number of tickets remaining
    let tickets: Int
}
