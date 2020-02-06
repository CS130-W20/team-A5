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
        VStack() {
            ZStack {
                Image(saleItem.image)
                .resizable()
                .frame(width: 360, height: 270)
                .cornerRadius(8)
//                    .shadow(color: Color.gray, radius: 15)
                Rectangle()
                .offset(y:155)
                .fill(Color.red)
                .frame(width: 360, height: 10)
                Text(saleItem.name)
                    .offset(x: -20, y: 120)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 15)
            }.padding(10)
            ZStack{
                Rectangle()
                .fill(Color.red)
                .frame(width: 360, height: 50)
                .cornerRadius(8)
                Text("Tickets left: 24")
                    .foregroundColor(Color.white)
            }
        }
        .frame(width: 500)
    }
}

