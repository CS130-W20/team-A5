//
//  SuccessfulView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct SuccessfulView: View {
    @State var num_of_tickets: String
    @ObservedObject var saleItem: SaleItem
    @EnvironmentObject var navigation: NavigationStack

    var body: some View {
        
        VStack(){
            Spacer()
            Image("ticket")
                .resizable()
                .frame(width: frameMaxWidth, height: frameMaxWidth)
            Spacer().frame(height: 50)
            Text("Congratulations!")
                .clearButtonText()
            
            Text("You successfully received \(self.num_of_tickets) Ticket(s) towards \(saleItem.item_name)!")
                .h2()
                .multilineTextAlignment(.center)
                
            Spacer()
            Button(action:{
                self.navigation.home()
            }){
                Text("Back to Home")
                    .blueButtonText()
            }.buttonStyle(BigBlueButtonStyle())
        }.frame(width: frameMaxWidth)
    }
}

//struct SuccessfulView_Previews: PreviewProvider {
//    static var previews: some View {
//        SuccessfulView()
//    }
//}
