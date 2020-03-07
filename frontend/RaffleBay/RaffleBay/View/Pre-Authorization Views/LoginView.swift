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
    @EnvironmentObject var navigation: NavigationStack
    
    @State private var selection: Int? = nil
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    @ObservedObject var newUser = User()
     var body: some View {
            HStack(){
                
                //Left Side Spacer
                Spacer()
                
                //Center Column
                VStack(){
                    Spacer().frame(height: 10)
                    HStack(){
                    
                        Button(action: {
                            self.navigation.splashscreen()
                        }){
                            Text("Back")
                        }
                        Spacer()
                    }
                    Spacer().frame(height: 40)
                    
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
                        Button(action: {
                                let response = login_request(email: self.email, password: self.password, authenticationVM: self.authenticationVM, user: self.newUser)
                                //self.selection = response
                                self.navigation.home()
                                
                        }){
                            Text("Login")
                                .blueButtonText()
                                .frame(minWidth:0, maxWidth: frameMaxWidth)
                        }
                        .buttonStyle(BigBlueButtonStyle())
                    }
                    
                    //Signup Button
                    Button(action: {
                        self.navigation.signup()
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
