//
//  ProfileSaleItemView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/17/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct ProfileBidItemView: View {
    @State var buyingItem: BuyingItem
    var body: some View {
        HStack(){
            Rectangle()
                .frame(width: frameMaxWidth * 0.4, height: frameMaxWidth * 0.4)
            
            VStack(alignment: .leading){
                Text(buyingItem.item_name)
                    .standardBoldText()
                Spacer().frame(height: 1)
                Text("Total Price: $\(buyingItem.sale_price)")
                    .standardRegularText()
                Text("Tickets Sold: \(buyingItem.tickets_sold)/\(buyingItem.total_tickets)")
                    .standardRegularText()
                Spacer().frame(height: 10)
                Text("Time Left: 01:44:23")
                    .fontWeight(.bold)
                    .font(.custom("Poppins", size: 14))
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(Color("PurpleBlue"))
                    )
                
            }
        }
        .background(Rectangle()
            .foregroundColor(Color.white)
            .shadow(radius: 7)
            .frame(width: frameMaxWidth * 1.1, height: frameMaxWidth * 1.1 / 2)
            )
        .padding(20)
        .frame(width: 400, height: frameMaxWidth * 1.2 / 2)
    }
    
}

//struct ProfileSaleItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSaleItemView()
//    }
//}
