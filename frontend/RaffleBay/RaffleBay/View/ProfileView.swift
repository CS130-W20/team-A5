//
//  ProfileView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/17/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(){
            HStack(){
                Spacer()
                VStack(){
                    Image("bose")
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 7)
                    Text("Pierson Marks")
                        .clearButtonText()
                    Text("Account Balance: $" + "47.00")
                        .standardBoldText()
                }
                Spacer()
            }
            
            HStack(){
                Button(action: {
                   
                }){
                   Text("Items Bid On")
                       .standardBoldText()
                       .padding(8)
                }
                
                Button(action: {
                    
                }){
                    Text("Items Listed")
                        .standardBoldText()
                        .padding(8)
                }
            }
            HStack(){
                Spacer()
                VStack(){
                    HStack(){
                        Text("Items You've Listed")
                            .standardBoldText()
                            .padding(8)
                        
                        Spacer()
                        
                        Button(action: {
                           
                        }){
                           Text("(+)")
                               .standardBoldText()
                               .padding(8)
                        }
                    }
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom)
                        .foregroundColor(Color("LightGray"))
                        .offset(y:-10)
                }
                Spacer()
            }
            
            List(){
                
                ProfileSaleItemView()
                ProfileSaleItemView()
                ProfileSaleItemView()
            }
            Spacer()
        
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
