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
    @EnvironmentObject var navigation: NavigationStack
    @State private var successfulSignup: Bool = true
    
    //Create some user and use a password confirmation var to confirm
    @ObservedObject var someUser = User()
    @State private var pwdConfirm = String()
    @State var value: CGFloat = 0
    
    var body: some View {
        
        
        ZStack(){
            
            
            //Stack for Back Button
            VStack(){
                Spacer()
                VStack(){
                    HStack(){
                        Spacer()
                            VStack(){
                                VStack(){
                                TextField("First Name", text: $someUser.firstName)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 0
                                    }
                                
                                TextField("Last Name", text: $someUser.lastName)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 1
                                    }
                
                                TextField("Email", text: $someUser.email)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 2
                                    }
                
                                SecureField("Password", text: $someUser.password)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 3
                                    }
                
                                SecureField("Password Confirmation", text: $pwdConfirm)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 4
                                    }
                
                                TextField("Street Address", text: $someUser.streetAddress)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 5
                                    }
                
                                TextField("City", text: $someUser.city)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 6
                                    }
                                
                                HStack(){
                                    TextField("State", text: $someUser.state)
                                    .textFieldStyle(SignUpTextFieldStyle())
                
                                    TextField("Zipcode", text: $someUser.zipcode)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                }
                                .onTapGesture {
                                    self.value = signupFrameHeight * 7
                                }
                
                                TextField("Phone Number", text: $someUser.phoneNumber)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 8
                                    }
                
                                TextField("Birthdate",  text: $someUser.birthdate)
                                    .textFieldStyle(SignUpTextFieldStyle())
                                    .onTapGesture {
                                        self.value = signupFrameHeight * 9
                                }
                                }
                                 Spacer()
                                
                                //Validations Here
                                if(someUser.password != pwdConfirm) {
                                    Text("Your passwords do not match.")
                                        .foregroundColor(.red)
                    
                                }else{
                                    //Validations Here
                                    if(!successfulSignup) {
                                        Text("Incorrect information. Fix errors and retry.")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                          
                                //Login Stack
                                //ZStack here to allow for custom shadow manipulation.
                                ZStack(){
                                    ShadowBoxView()
                    
                                    //SignUp Button
                                    Button(action: {
                                            let response = post_signup(newUser: self.someUser)
                    
                                            if(response == 1){
                                                self.navigation.home()
                                            }else{
                                                self.successfulSignup = false
                                            }
                    
                                    }){
                                        Text("Sign Up")
                                            .blueButtonText()
                                            .frame(minWidth:0, maxWidth: frameMaxWidth)
                                    }
                                    .buttonStyle(BigBlueButtonStyle())
                                }
                    
                                //Login Button
                                Button(action: {
                                    self.navigation.login()
                                }){
                                    HStack(){
                                        Text("Have an account?")
                                            .standardRegularText()
                                            .padding(8)
                                        Text("Login Here")
                                            .standardBoldText()
                                            .padding(8)
                                   }
                                }
                                .buttonStyle(BigClearButtonStyle())
                                
    
                            }.offset(y: -self.value)
                                .animation(.spring())
                                .onAppear(){
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                                        self.value = 0
                                    }
                                }
                        Spacer()
                    }
                }
            }.offset(y:signupFrameHeight * 0.7)
    
            ZStack(){
               Rectangle()
                   .fill()
                   .foregroundColor(Color.white)
                   .frame(height: 80)
                   .offset(y:0)
               HStack(){
                   Button(action: {
                       self.navigation.splashscreen()
                   }){
                       Text("Back")
                   }.offset(y:20)
                   Spacer()
               }.padding()

            }.offset(y:signupFrameHeight * -6.8)
            
        }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}


//HStack(){
//
//        //Left Side Spacer
//        Spacer()
//
//        //Center Column
//        VStack(){
//            VStack(){
//                TextField("First Name", text: $someUser.firstName)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 0
//                    }
//
//                TextField("Last Name", text: $someUser.lastName)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 1
//                    }
//
//                TextField("Email", text: $someUser.email)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 2
//                    }
//
//                SecureField("Password", text: $someUser.password)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 3
//                    }
//
//                SecureField("Password Confirmation", text: $pwdConfirm)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 4
//                    }
//
//                TextField("Street Address", text: $someUser.streetAddress)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 5
//                    }
//
//                TextField("City", text: $someUser.city)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 6
//                    }
//
//                HStack(){
//                    TextField("State", text: $someUser.state)
//                    .textFieldStyle(SignUpTextFieldStyle())
//
//                    TextField("Zipcode", text: $someUser.zipcode)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                }
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 7
//                    }
//
//                TextField("Phone Number", text: $someUser.phoneNumber)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .keyboardType(.numberPad)
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 8
//                    }
//
//
//                TextField("Birthdate",  text: $someUser.birthdate)
//                    .textFieldStyle(SignUpTextFieldStyle())
//                    .onTapGesture {
//                        self.value = signupFrameHeight * 9
//                    }
//            }
//
//            Spacer()
//
//            //Validations Here
//            if(someUser.password != pwdConfirm) {
//                Text("Your passwords do not match.")
//                    .foregroundColor(.red)
//
//            }else{
//                //Validations Here
//                if(!successfulSignup) {
//                    Text("Incorrect information. Fix errors and retry.")
//                        .foregroundColor(.red)
//                }
//            }
//
//            //Login Stack
//            //ZStack here to allow for custom shadow manipulation.
//            ZStack(){
//                ShadowBoxView()
//
//                //SignUp Button
//                Button(action: {
//                        let response = post_signup(newUser: self.someUser)
//
//                        if(response == 1){
//                            self.navigation.home()
//                        }else{
//                            self.successfulSignup = false
//                        }
//
//                }){
//                    Text("Sign Up")
//                        .blueButtonText()
//                        .frame(minWidth:0, maxWidth: frameMaxWidth)
//                }
//                .buttonStyle(BigBlueButtonStyle())
//            }
//
//            //Login Button
//            Button(action: {
//                self.navigation.login()
//            }){
//                HStack(){
//                    Text("Have an account?")
//                        .standardRegularText()
//                        .padding(8)
//                    Text("Login Here")
//                        .standardBoldText()
//                        .padding(8)
//               }
//            }
//            .buttonStyle(BigClearButtonStyle())
//
//            }
//            .offset(y: -self.value)
//            .animation(.spring())
//            .onAppear(){
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
//                    self.value = 0
//                }
//            }
//
//        //Right Side Spacer
//        Spacer()
//    }
//}
