//
//  ProfileView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/17/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

let circleDiameter: CGFloat = 30


struct ProfileView: View {
    @ObservedObject var currUser = User()
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    var body: some View {
        NavigationView {
        VStack(){
            HStack(){
                Button(action: {
                    self.authenticationVM.auth_token = ""
                }){
                   Text("logout")
                       .h1()
                }
                Spacer()
                HamburgerIconView()
            }.padding()
                
            HStack(){
                Spacer()
                VStack(){
                    Image("bose")
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 7)
                    Text("\(currUser.firstName) \(currUser.lastName)")
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
                VStack(alignment: .center){
                    HStack(alignment: .bottom){
                        Text("Items You've Listed")
                            .standardBoldText()
                            
                        
                        Spacer()
                        NavigationLink(destination: UploadSaleItemView()) {
                            
                            PlusButtonView()
                        }
                    }
                    .padding(8)
                    Rectangle()
                        .frame(height: 2.0, alignment: .bottom)
                        .foregroundColor(Color("LightGray"))
                        .offset(y:-10)
                    
                    ScrollView(){
                        ProfileSaleItemView()
                        ProfileSaleItemView()
                        ProfileSaleItemView()
                    }
                }
            }
        }
        }
    .navigationBarBackButtonHidden(true)
        .onAppear {get_user_request(auth_token: self.authenticationVM.auth_token, user: self.currUser)}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
