//
//  SidebarNavView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct SidebarNavView: View {
    @EnvironmentObject var navigation: NavigationStack
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    @State private var showing_add_fund_model = false
    var body: some View {
        VStack(){
            HStack(){
                Button(action: {
                     self.navigation.unwind()
                }){
                     HamburgerIconView()
                }
                .foregroundColor(Color("LightGray"))
                Spacer()
                
            }.padding()
            Spacer()
            HStack(){
                
                Spacer()
                VStack(){
                        Button(action: {
                            self.navigation.home()
                        }){
                            Text("Home")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding()
                    
                        Button(action: {
                             self.navigation.advance(
                                                   NavigationItem( view: AnyView(ProfileView())))
                        }){
                            Text("Profile")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding()
                        Button(action: {
                            self.showing_add_fund_model.toggle()
//                             self.navigation.advance(
//                                                   NavigationItem( view: AnyView(AddFundsWrapper(authenticationVM: self.authenticationVM))))
                        }){
                            Text("Add Funds")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding()
                        .sheet(isPresented: $showing_add_fund_model) {
                            AddFundsWrapper()
                        }
                        Spacer().frame(height: 80)
//                        Button(action: {
//                                
//                        }){
//                            Text("Settings")
//                                .foregroundColor(Color.gray)
//                                .fontWeight(.semibold)
//                                .font(.custom("Poppins", size: 24))
//                            }.padding().disabled(true)
                        
                        Button(action: {
                                self.authenticationVM.auth_token = ""
                                self.navigation.splashscreen()
                        }){
                            Text("Logout")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding()
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct SidebarNavView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavView()
    }
}
