//
//  CreateSaleItem.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct CreateSaleItem: View {
    @ObservedObject var newSaleItem: SaleItem
    var body: some View {
        VStack(){
            Spacer().frame(height: 100)
            VStack(alignment: .leading) {
                Image("bose")
                    .resizable()
                    .frame(maxWidth: 350, maxHeight: 200)
                
                Text(newSaleItem.item_name)
                    .h1()
                Text(newSaleItem.item_description)
                    .h2()
                
            }
            Spacer()
            VStack(alignment: .center){
                Text("Raffle Duration: 14 Days")
                    .fontWeight(.bold)
            }
            VStack(alignment: .leading){
                HStack(){
                    Text("Total List Price: ")
                        .clearButtonText()
                    Spacer()
                    Text(newSaleItem.sale_price)
                        .clearButtonText()
                }
                HStack(){
                    Text("Tickets to Sell: ")
                        .clearButtonText()
                    Spacer()
                    Text(newSaleItem.total_tickets)
                        .clearButtonText()
                }
            }.padding(20)
            NavigationLink(destination: ProfileView()){
                Text("Add Listing")
                  .blueButtonText()
                  .frame(minWidth:0, maxWidth: frameMaxWidth)
            }
            .buttonStyle(BigBlueButtonStyle())
        }.padding(40)
    }
}

//struct CreateSaleItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateSaleItem(newSaleItem: SaleItem)
//    }
//}
