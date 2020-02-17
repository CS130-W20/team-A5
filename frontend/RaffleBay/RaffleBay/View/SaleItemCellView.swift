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
    let cellHeight:CGFloat = 200
    let cellWidth:CGFloat = 400
    
    
    var body: some View {
        
        VStack(){
            ZStack(){
                Image(saleItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cellWidth, height: cellHeight)
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
                .frame(width: cellWidth, height: cellHeight/4)
                .foregroundColor(Color("LightYellow"))
                
                Text("Buy Tickets")
                    .blueButtonText()
                    
                
            }
            
                
                
        }.cornerRadius(8)
            
        
        
        
//        VStack() {
//            ZStack {
//                Image(saleItem.image)
//                .resizable()
//                .frame(width: 360, height: 270)
//                .cornerRadius(8)
////                    .shadow(color: Color.gray, radius: 15)
//                Rectangle()
//                .offset(y:155)
//                .fill(Color.red)
//                .frame(width: 360, height: 10)
//                Text(saleItem.name)
//                    .offset(x: -20, y: 120)
//                    .foregroundColor(Color.white)
//                    .shadow(color: Color.black, radius: 15)
//            }.padding(10)
//            ZStack{
//                Rectangle()
//                .fill(Color.red)
//                .frame(width: 360, height: 50)
//                .cornerRadius(8)
//                Text("Tickets left: 24")
//                    .foregroundColor(Color.white)
//            }
//        }
//        .frame(width: 500)
    }
}
