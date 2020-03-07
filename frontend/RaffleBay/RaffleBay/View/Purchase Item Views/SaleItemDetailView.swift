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

    let saleItem: SaleItem
    @EnvironmentObject var navigation: NavigationStack
    
    @State private var num_of_tickets: Int? = 0
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
            }.padding(20)
        }.padding()
    }
}

//struct SaleItemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaleItemDetailView(saleItem: saleItems[0])
//    }
//}
