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
                            .textFieldStyle(SignUpStyle())
                      
                        SecureField("Password", text: $password)
                            .textFieldStyle(SignUpStyle())
                        
                    }
                    
                    Spacer().frame(height: 30)
                    
                    //Login Stack
                    //ZStack here to allow for custom shadow manipulation.
                    VStack(){
                        //Create a Rectangle behind the button to simulate a smaller shadow for a 3D effect.
                        RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(minWidth:0, maxWidth: 300, minHeight:10, maxHeight: 10)
                        .shadow(color: Color("PurpleBlue"), radius: 5.0, x: 0, y: 10)
                        .offset(y:22)
                        .opacity(0.6)

                        //Login Button
                        NavigationLink(destination: SaleItemTableView(), tag: 1, selection: self.$selection){
                            Text("")
//                                .fontWeight(.medium)
//                                .padding(10)
//                                .font(.custom("Poppins", size: 30))
//                                .foregroundColor(Color.white)
//                                .frame(minWidth:0, maxWidth: 300)
                        }
                        .frame(minWidth:0, maxWidth: 300)
                        .background(ButtonGradient)
                        .cornerRadius(7)
                        Button("Login") {self.selection =  login_request(email: "longerbeamalex@gmail.com", password: "PASSWORD1")}
                        }
                    
//                                        ZStack(){
//                                            //Create a Rectangle behind the button to simulate a smaller shadow for a 3D effect.
//                                            RoundedRectangle(cornerRadius: 25)
//                                            .fill(Color.white)
//                                            .frame(minWidth:0, maxWidth: 250, minHeight:10, maxHeight: 10)
//                                            .shadow(color: Color("PurpleBlue"), radius: 5.0, x: 0, y: 10)
//                                            .offset(y:22)
//                                            .opacity(0.6)
//
//                    //                        //Login Button
//                    //                        Button(action: {
//                    //
//                    //                        }){
//                    //                            Text("Login")
//                    //                                .fontWeight(.medium)
//                    //                                .padding(10)
//                    //                                .font(.custom("Poppins", size: 30))
//                    //                                .foregroundColor(Color.white)
//                    //                                .frame(minWidth:0, maxWidth: 300)
//                    //                        }
//                    //                        .frame(minWidth:0, maxWidth: 300)
//                    //                        .background(ButtonGradient)
//                    //                        .cornerRadius(7)
//                                            NavigationLink(destination: LoginView()){
//                                                Text("Login")
//                                                    .fontWeight(.medium)
//                                                    .padding(10)
//                                                    .font(.custom("Poppins", size: 30))
//                                                    .foregroundColor(Color.white)
//                                                    .frame(minWidth:0, maxWidth: 300)
//                                            }
//                                            .frame(minWidth:0, maxWidth: 300)
//                                            .background(ButtonGradient)
//                                            .cornerRadius(7)
//                                        }
                    
                    
                    //Signup Button
                    //Login Button
                    Button(action: {
                        
                    }){
                        Button(action: {
                            
                        }){
                            HStack(){
                                Text("Don't have an account?")
                                .fontWeight(.regular)
                                .padding(8)
//                                .font(.custom("Poppins", size: 14))
                                .foregroundColor(Color.gray)
                   
                                
                                Text("Sign Up")
                                .fontWeight(.bold)
                                .padding(8)
//                                .font(.custom("Poppins", size: 14))
                                .foregroundColor(Color.gray)
                                
                            }
                        }
                        
                        
                            
                    }
                    .frame(minWidth:0, maxWidth: 375)
                    .cornerRadius(7)
                 
                    Spacer()
                    
                }.frame(minWidth:0, maxWidth: 375)
                
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
