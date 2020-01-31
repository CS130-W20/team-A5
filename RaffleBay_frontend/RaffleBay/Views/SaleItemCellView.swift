//
//  SaleItemCellView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 1/30/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct SaleItemCellView: View {
   
    let saleItem: SaleItem
    
    var body: some View {
        
        VStack {
            ZStack {
                Image(saleItem.image)
                .resizable()
                .frame(width: 160, height: 240)
                .cornerRadius(8)
                Text(saleItem.name)
            }
        }

    }
}
