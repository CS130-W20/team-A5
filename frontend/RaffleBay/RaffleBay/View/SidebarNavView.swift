//
//  SidebarNavView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/18/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct SidebarNavView: View {
    var body: some View {
        ZStack(){
            HStack(){
                VStack(){
                    Button(action: {
                        
                    }){
                         HamburgerIconView()
                    }
                    .padding(40)
                    .foregroundColor(Color("LightGray"))
                    Spacer()
                }
                Spacer()
            }
            HStack(){
                
                Spacer()
                VStack(){
                        Button(action: {
                            
                        }){
                            Text("Home")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding(10)
                    
                        Button(action: {
                            
                        }){
                            Text("Profile")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding(10)
                        Spacer().frame(height: 80)
                        Button(action: {
                                
                        }){
                            Text("Setting")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding(10)
                        
                        Button(action: {
                                
                        }){
                            Text("Logout")
                                .foregroundColor(Color.gray)
                                .fontWeight(.semibold)
                                .font(.custom("Poppins", size: 24))
                        }.padding(10)
                }
                Spacer()
           
            }
        }
    }
}

struct SidebarNavView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavView()
    }
}
