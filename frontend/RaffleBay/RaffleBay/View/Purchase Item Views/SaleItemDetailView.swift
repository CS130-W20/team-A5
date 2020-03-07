//
//  SaleItemDetailView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI
import Security

//Securely generate random numbers in Swift.
//gathers entropy from the system on clock cycles and other impossible to predict data
func generateRandomNumber() -> Int {
    let bytesCount = 4
    var random: UInt32 = 0
    var randomBytes = [UInt8](repeating: 0, count: bytesCount)
    var returnVal: Int

    SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomBytes)

    NSData(bytes: randomBytes, length: bytesCount)
      .getBytes(&random, length: bytesCount)

    returnVal = Int(random)
    
    return returnVal
}


struct SaleItemDetailView : View {
    @ObservedObject var currUser = User()
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    @ObservedObject var saleItem: SaleItem
    
    @State private var num_of_tickets = ""
    @State private var showingAlert = false
    @State private var error_message = "Not enough funds. Please add more funds"
    

    @EnvironmentObject var navigation: NavigationStack
    
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
            }.padding(20)
            VStack(){
                VStack(alignment: .leading) {
                    Image(saleItem.pic_url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 200)
                        .clipped()
                    Text(saleItem.item_name)
                        .h1()
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                             Text("Ticket Price: ")
                               .h2()
                            Text(saleItem.ticket_price)
                                .foregroundColor(Color("PurpleBlue"))
                        }
                       
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("Expires at 5pm PST on:")
                                .h2()
                            Text(saleItem.created_at)
                                .foregroundColor(Color.red)
                        }
                    }
                
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom)
                        .foregroundColor(Color("LightGray"))
                
                    HStack(){
                        Text(saleItem.total_tickets) //This is wrong (or improperly named). I'm assuming this is "Total Tickets Remaining"
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(Color("PurpleBlue")))
                        Text("Tickets Left")
                        Spacer()
                        VStack(alignment: .trailing){
                            //Need to make an API request for the seller name from id
                            Text("Seller: " + String(saleItem.seller_id))
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
                    Text("Tickets to purchase:")
                    TextField("Enter the # of tickets you wish to buy", text: self.$num_of_tickets)
                    }.padding(20)
                    
                    Button(action:{
                        print(self.currUser.account_balance)
                        print(self.saleItem.ticket_price)
                        let generatedRand: Int = generateRandomNumber()
                        if Double(self.currUser.account_balance)! >= Double(self.saleItem.ticket_price)! * Double(self.num_of_tickets)! {
                            post_bid_on_item(saleItem: self.saleItem, auth_token: self.authenticationVM.auth_token, num_of_tickets: self.num_of_tickets, rand_seed: generatedRand)
                            self.navigation.success(numOfTickets: self.num_of_tickets, SaleItem: self.saleItem)
                        } else {
                            self.showingAlert = true
                        }
                    }){
                        Text("Buy Now")
                            .blueButtonText()
                    }.buttonStyle(BigBlueButtonStyle())
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(self.error_message), message: Text(""), dismissButton: .default(Text("Got it!")))
                }
            }.padding(20)
        }.padding()
    }
}

//struct SaleItemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaleItemDetailView(saleItem: saleItems[0])
//    }
//}
