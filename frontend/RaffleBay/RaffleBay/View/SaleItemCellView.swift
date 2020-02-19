//
//  SaleItemCellView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct SaleItemCellView: View {
   
    let saleItem: SaleItem
    let cellHeight:CGFloat = 250
    let cellWidth:CGFloat = 175
    
    
    var body: some View {
        
        VStack(spacing: 0){
            ZStack(){
                Image(saleItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: cellWidth, maxHeight: cellHeight)
                    .foregroundColor(Color("LightBlue"))
                
                HStack(){
                    VStack(){
                        Spacer()
                        Text(saleItem.name)
                            .saleItemText()
                            .shadow(radius: 1)
                    }.offset(x:cellWidth/40)
                    Spacer()
                }
            }
            
            ZStack(){
                Rectangle()
                .frame(maxWidth: cellWidth, maxHeight: cellHeight/5)
                .foregroundColor(Color("LightYellow"))
                
                Text("Buy Tickets")
                    .standardBoldText()
            }
        }
        .frame(maxWidth: cellWidth, maxHeight: cellHeight)
        .cornerRadius(cellWidth/20)
        .shadow(radius: 3, y: 5)
    }
}
