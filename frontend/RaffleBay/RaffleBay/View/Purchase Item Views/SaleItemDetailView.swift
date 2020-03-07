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
    @EnvironmentObject var navigation: NavigationStack

    @State private var num_of_tickets: Int? = 0
//    let saleItem: SaleItem
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
                    Text("Bose QuietComfort 100")
                        .h1()
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                             Text("Ticket Price: ")
                               .h2()
                            Text("$15.00")
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
                        Text("8")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(Color("PurpleBlue")))
                        Text("Tickets Left")
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("Posted 5 Days Ago")
                            Text("Seller: Jennifer Smith")
                        }
                    }
                    
                    Rectangle()
                       .frame(height: 1.0, alignment: .bottom)
                       .foregroundColor(Color("LightGray"))
                    
                    VStack(alignment: .leading){
                        Text("Description:")
                            .fontWeight(.bold)
                        Text("Lorem Ipsum dolor set amet.")
                    }
                }
                Spacer()
                VStack(alignment: .center){
                    Text("How many tickets would you like to purchase?:")

                    Text("1")
                        .fontWeight(.bold)
                }.padding(20)
                
                Button(action:{
                    self.navigation.success()
                }){
                    Text("Buy Now")
                        .blueButtonText()
                }.buttonStyle(BigBlueButtonStyle())
            }.padding(40)
        }
    }
}

struct SaleItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SaleItemDetailView()
    }
}
