//
//  CreateSaleItem.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct CreateSaleItem: View {
    var body: some View {
        VStack(){
            Spacer().frame(height: 100)
            VStack(alignment: .leading) {
                Image("bose")
                    .resizable()
                    .frame(maxWidth: 350, maxHeight: 200)
                
                Text("saleItem.name")
                    .h1()
                Text("Description")
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
                    Text("$50.00")
                        .clearButtonText()
                }
                HStack(){
                    Text("Tickets to Sell: ")
                        .clearButtonText()
                    Spacer()
                    Text("10")
                        .clearButtonText()
                }
            }.padding(20)
            Button(action:{
               
            }){
                Text("Add Listing")
                    .blueButtonText()
            }.buttonStyle(BigBlueButtonStyle())
        }.padding(40)
    }
}

struct CreateSaleItem_Previews: PreviewProvider {
    static var previews: some View {
        CreateSaleItem()
    }
}
