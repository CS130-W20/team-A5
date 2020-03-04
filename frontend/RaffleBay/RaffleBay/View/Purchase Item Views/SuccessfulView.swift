//
//  SuccessfulView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct SuccessfulView: View {
    var body: some View {
        
        VStack(){
            Spacer()
            Image("ticket")
                .resizable()
                .frame(width: frameMaxWidth, height: frameMaxWidth)
            Spacer().frame(height: 50)
            Text("Congratulations!")
                .clearButtonText()
            
            Text("You successfully received 1 Ticket towards Emily's Green Blazer!")
                .h2()
                .multilineTextAlignment(.center)
                
            Spacer()
            Button(action:{
               
            }){
                Text("Back to Home")
                    .blueButtonText()
            }.buttonStyle(BigBlueButtonStyle())
        }.frame(width: frameMaxWidth)
    }
}

struct SuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfulView()
    }
}
