//
//  CreateSaleItem.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct CreateSaleItem: View {
    @EnvironmentObject var navigation: NavigationStack
    
    @ObservedObject var newSaleItem: SaleItem
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    var body: some View {
            
        VStack(){
            HStack(){
                Button(action: {
                    self.navigation.unwind()
                }){
                   Text("Back")
                        .foregroundColor(Color.gray)
                        .fontWeight(.semibold)
                        .font(.custom("Poppins", size: 24))
                }
                Spacer()
            }.padding()
            VStack(){

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
                    Text("Raffle Duration: 7 Days")
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
                Button(action:{
                    post_sale_item(auth_token: self.authenticationVM.auth_token, saleItem: self.newSaleItem)
                    self.navigation.home()
                }){
                    Text("Confirm Listing")
                        .blueButtonText()
                        .frame(minWidth:0, maxWidth: frameMaxWidth)
                }.buttonStyle(BigBlueButtonStyle())
            }.padding(40)
        }
    }
}

//struct CreateSaleItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateSaleItem(newSaleItem: SaleItem)
//    }
//}
