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
    @State private var num_of_tickets = ""
    @State private var showingAlert = false
    @State private var message = "Ticket Purchase Confirmed"
    
    @ObservedObject var currUser = User()
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    @ObservedObject var saleItem: SaleItem
//    let saleItem: SaleItem
    var body: some View {
        VStack(){
            Spacer().frame(height: 60)
            VStack(alignment: .leading) {
                Image("bose")
                    .resizable()
                    .frame(maxWidth: 350, maxHeight: 200)
                Text(saleItem.item_name)
                    .h1()
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                         Text("Ticket Price: ")
                           .h2()
                        Text("$\(saleItem.ticket_price)")
                            .foregroundColor(Color("PurpleBlue"))
                    }
                   
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("Time Remaining:")
                            .h2()
                        Text("00:45:31")
                            .foregroundColor(Color.red)
                    }
                }
                
                Rectangle()
                    .frame(height: 1.0, alignment: .bottom)
                    .foregroundColor(Color("LightGray"))
                
                HStack(){
                    Text(saleItem.total_tickets)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 2)
                            .foregroundColor(Color("PurpleBlue")))
                    Text("Tickets Left")
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("Posted 5 Days Ago")
//                        Text("Seller: Jennifer Smith")
                    }
                }
                
                Rectangle()
                   .frame(height: 1.0, alignment: .bottom)
                   .foregroundColor(Color("LightGray"))
                
                VStack(alignment: .leading){
                    Text("Description:")
                        .fontWeight(.bold)
                    Text(saleItem.item_description)
                }
            }
            Spacer()
            VStack(alignment: .center){
                Text("How many tickets would you like to purchase?:")

                
                TextField("Enter the # of tickets you wish to buy", text: self.$num_of_tickets)
            }.padding(20)
            Button(action:{
                if Int(self.currUser.account_balance)! >= Int(self.saleItem.ticket_price)! * Int(self.num_of_tickets)! {
                    post_bid_on_item(saleItem: self.saleItem, auth_token: self.authenticationVM.auth_token, num_of_tickets: self.num_of_tickets)
                    self.showingAlert = true
                } else {
                    self.message = "Not enough funds. Add more funds to your account"
                    self.showingAlert = true
                }
               
            }){
                Text("Buy Now")
                    .blueButtonText()
            }.buttonStyle(BigBlueButtonStyle())
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(self.message), message: Text(""), dismissButton: .default(Text("Got it!")))
            }
        }.padding(40)
    }
}

//struct SaleItemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaleItemDetailView()
//    }
//}
