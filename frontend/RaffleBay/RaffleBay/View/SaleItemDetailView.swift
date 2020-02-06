//
//  SaleItemDetailView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

struct SaleItemDetailView : View {

    let saleItem: SaleItem
    var body: some View {
        VStack(alignment: .center) {
            Image("bose")
            
            Text(saleItem.name)
            Button(action: {
                print("button worked")
            }) {
                Text("Buy Now")
            }
        }
    }
}
