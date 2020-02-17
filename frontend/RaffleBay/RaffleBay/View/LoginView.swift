//
//  LoginView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/9/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI
import Foundation
import Alamofire_SwiftyJSON

struct LoginView: View {
    @State private var selection: Int? = nil
    @State private var email: String = ""
    @State private var password: String = ""
    
     var body: some View {
            HStack(){
                
                //Left Side Spacer
                Spacer()
                
                //Center Column
                VStack(){
                    //Spacer().frame(height: 70)
                    
                    VStack(){
                        TextField("Email", text: $email)
                            .textFieldStyle(SignUpTextFieldStyle())
                      
                        SecureField("Password", text: $password)
                            .textFieldStyle(SignUpTextFieldStyle())
                        
                    }
                    
                    Spacer().frame(height: 30)
                    
                    //Login Stack
                    //ZStack here to allow for custom shadow manipulation.
                    ZStack(){
                        ShadowBoxView()

                        //Login Button
                        //Personal Comment: Should we not have a natigation link here? I haven't looked into this yet but I'm assuming when we have a real DB hooked up, the view will change prior to recieving confirmation from the DB if the user input is correct
                        NavigationLink(destination: SaleItemTableView(), tag: 1, selection: self.$selection){
                            Button(action: {
                                self.selection =  login_request(email: "longerbeamalex@gmail.com", password: "PASSWORD1")
                            }){
                                Text("Login")
                                    .blueButtonText()
                                    .frame(minWidth:0, maxWidth: 300)
                                    
                            }
                        }
                        .buttonStyle(BigBlueButtonStyle())
                    }
                    
                    //Signup Button
                    Button(action: {
                        
                    }){
                        Button(action: {
                            
                        }){
                            HStack(){
                                Text("Don't have an account?")
                                    .standardRegularText()
                                    .padding(8)
                                
                                Text("Sign Up")
                                    .standardBoldText()
                                    .padding(8)
                            }
                        }
                    }
                    .buttonStyle(BigClearButtonStyle())
                 
                    Spacer()
                }
                
                //Right Side Spacer
                Spacer()
            }
        
        }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
