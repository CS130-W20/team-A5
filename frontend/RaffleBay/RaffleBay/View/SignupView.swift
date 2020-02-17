//
//  SignupView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON



//TO DO:
//Figure out a way when clicking outside of the form area
//the keyboard should be dismissed.


struct SignupView : View {
    
    //Create a User
    let user : User
   
    
    //Format Date inputs
    var dateFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateStyle = .long
           return formatter
       }

    @State var value :CGFloat = 0
    
    var body: some View {
        
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            
            VStack(){
                //Spacer().frame(height: 50)
                
                VStack(){
                    TextField("First Name", text: user.$firstName)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 0
                        }
                  
                    TextField("Last Name", text: user.$lastName)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 1
                        }
                    
                    TextField("Email", text: user.$email)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 2
                        }
                    
                    SecureField("Password", text: user.$password)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 3
                        }
                        
                    SecureField("Password Confirmation", text: user.$passwordComfirmation)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 4
                        }

                    TextField("Street Address", text: user.$streetAddress)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 5
                        }

                    TextField("City", text: user.$city)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 6
                        }
                    
                    HStack(){
                        TextField("State", text: user.$state)
                        .textFieldStyle(SignUpTextFieldStyle())
                        
                        TextField("Zipcode", text: user.$zipcode)
                        .textFieldStyle(SignUpTextFieldStyle())
                    }
                        .onTapGesture {
                            self.value = signupFrameHeight * 7
                        }
                    
                    TextField("Phone Number", text: user.$phoneNumber)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            self.value = signupFrameHeight * 8
                        }
                    
//                    DatePicker("Birthdate", selection: $birthdate, in: ...Date(), displayedComponents: .date)
//                        .labelsHidden()
//                        .textFieldStyle(SignUpTextFieldStyle())
                }
                
                Spacer()
                
                //Login Stack
                //ZStack here to allow for custom shadow manipulation.
                ZStack(){
                    ShadowBoxView()
                    
                    //Signup Button
                    Button(action: {
                        
                    }){
                        Text("Signup")
                            .blueButtonText()
                            .frame(minWidth:0, maxWidth: 300)
                    }
                    .buttonStyle(BigBlueButtonStyle())
                }
                
                //Login Button
                 NavigationLink(destination: LoginView()){
                    Button(action: {
                        
                    }){
                        HStack(){
                            Text("Already have an account?")
                                .standardRegularText()
                                .padding(8)
               
                            Text("Login Here")
                                 .standardBoldText()
                                .padding(8)
                        }
                    }

                }
                .buttonStyle(BigClearButtonStyle())
             
                }
                .offset(y: -self.value)
                .animation(.spring())
                .onAppear(){
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                        self.value = 0
                    }
                }
            
            //Right Side Spacer
            Spacer()
        }
    }
}

