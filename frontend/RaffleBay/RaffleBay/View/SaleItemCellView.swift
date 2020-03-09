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
    
    
    
    var body: some View {
        
        VStack(spacing: 0){
            ZStack(){
                Image("bose")//saleItem.pic_url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cellWidth, height: cellHeight * 0.7)
                    .clipped()
                
                HStack(){
                    VStack(){
                        Spacer()
                        Text(saleItem.item_name)
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

struct SaleItemCellView_Previews: PreviewProvider {
    static var previews: some View {
        SaleItemCellView(saleItem: SaleItemTestData.saleItems()[0])
    }
}
