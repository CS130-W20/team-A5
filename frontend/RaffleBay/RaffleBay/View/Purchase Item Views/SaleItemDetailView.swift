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
    @State private var seller_name = ""
    @State private var currencyTicketPrice = Double()
    

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
                    Image.load(picURL: saleItem.pic_url)
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
                            Text(convertDoubleToCurrency(amount: currencyTicketPrice))
                                .foregroundColor(Color("PurpleBlue"))
                        }
                       
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("Expires at 12AM PST on:")
                                .h2()
                            Text(saleItem.created_at)
                                .foregroundColor(Color.red)
                        }
                    }
                
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom)
                        .foregroundColor(Color("LightGray"))
                
                    HStack(){
                        Text(String((Int(saleItem.total_tickets) ?? 0) - (Int(saleItem.tickets_sold) ?? 0)))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(Color("PurpleBlue")))
                        Text("Tickets Left")
                        Spacer()
                        VStack(alignment: .trailing){
                            //Need to make an API request for the seller name from id
                            Text("Seller:")
                                .bold()
                            Text("\(self.seller_name)")
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
                        .standardBoldText()
                    TextField("# of Tickets", text: self.$num_of_tickets)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .multilineTextAlignment(.center)
                    }.padding(20)
                    
                    Button(action:{
                        print(self.currUser.account_balance)
                        print(self.saleItem.ticket_price)
                        let generatedRand: Int = generateRandomNumber()
                        if (self.num_of_tickets == "") {
                            self.showingAlert = true
                            self.error_message = "Please enter the number of tickets you wish to buy"
                        } else {
                            if(self.num_of_tickets != "0"){
                                if Double(self.currUser.account_balance)! >= Double(self.saleItem.ticket_price)! * Double(self.num_of_tickets)! {
                                    post_bid_on_item(saleItem: self.saleItem, auth_token: self.authenticationVM.auth_token, num_of_tickets: self.num_of_tickets, rand_seed: generatedRand){
                                        response in
                                        if response == true {
                                            
                                            self.navigation.success(numOfTickets: self.num_of_tickets, SaleItem: self.saleItem)
                                        } else {
                                            self.showingAlert = true
                                            self.error_message = "Please fix your errors and retry."
                                        }
                                    }
                                   
                                } else {
                                    self.error_message = "Not enough funds. Please add more funds"
                                    self.showingAlert = true
                                }
                            }
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
            .onAppear{
                get_seller_name(auth_token: self.authenticationVM.auth_token, user_id: String(self.saleItem.seller_id)) {
                response in
                self.seller_name = response

                    self.currencyTicketPrice = Double(self.saleItem.ticket_price) as! Double
                    
            }
        
        }
    }
}

//struct SaleItemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaleItemDetailView(saleItem: saleItems[0])
//    }
//}
