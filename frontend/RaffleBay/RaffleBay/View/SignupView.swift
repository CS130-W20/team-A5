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

//Button Gradient
let ButtonGradient = LinearGradient(gradient: Gradient(colors: [Color("PurpleBlue"), Color("LightBlue")]), startPoint: .leading, endPoint: .trailing)

//Size of the frames for the Text Fields - used to adjust keyboard hiding.
var signupFrameHeight: CGFloat = 60

//UI SignUp Style - DRY Principle
struct SignUpStyle : TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        
            VStack{
            configuration
                .font(.custom("Poppins", size: 24))
                .padding()
                .frame(height: signupFrameHeight)

                Rectangle()
                    .frame(height: 1.0, alignment: .bottom)
                    .foregroundColor(Color("LightGray"))
                    .offset(y:-10)
            }
    }
}

//TO DO:
//Figure out a way when clicking outside of the form area
//the keyboard should be dismissed.


struct SignupView : View {
    
    //I don't know if this is the best/correct way to accept input.
    //Another way I think could work is like a hashmap that maps inputs to their associated values. Will look into that.
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordComfirmation: String = ""
    @State private var streetAddress: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipcode: String = ""
    @State private var phoneNumber: String = ""
    @State private var birthdate = Date()
    
    //Format Date inputs
    var dateFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateStyle = .long
           return formatter
       }

    @State var value : CGFloat = 0
    
    var body: some View {
        
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            
            VStack(){
                //Spacer().frame(height: 50)
                
                VStack(){
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 0
                        }
                  
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 1
                        }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 2
                        }
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 3
                        }
                        
                    SecureField("Password Confirmation", text: $passwordComfirmation)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 4
                        }

                    TextField("Street Address", text: $streetAddress)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 5
                        }

                    TextField("City", text: $city)
                        .textFieldStyle(SignUpStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 6
                        }
                    
                    HStack(){
                        TextField("State", text: $state)
                        .textFieldStyle(SignUpStyle())
                        
                        TextField("Zipcode", text: $zipcode)
                        .textFieldStyle(SignUpStyle())
                    }
                        .onTapGesture {
                            self.value = signupFrameHeight * 7
                        }
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(SignUpStyle())
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            self.value = signupFrameHeight * 8
                        }
                    
//                    DatePicker("Birthdate", selection: $birthdate, in: ...Date(), displayedComponents: .date)
//                        .labelsHidden()
//                        .textFieldStyle(SignUpStyle())
                        
                    
                }
                
                Spacer()
                
                //Login Stack
                //ZStack here to allow for custom shadow manipulation.
                ZStack(){
                    //Create a Rectangle behind the button to simulate a smaller shadow for a 3D effect.
                    RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .frame(minWidth:0, maxWidth: 300, minHeight:10, maxHeight: 10)
                    .shadow(color: Color("PurpleBlue"), radius: 5.0, x: 0, y: 10)
                    .offset(y:22)
                    .opacity(0.6)
                    
                    //Signup Button
                    Button(action: {
                        
                    }){
                        Text("Signup")
                            .fontWeight(.medium)
                            .padding(10)
                            .font(.custom("Poppins", size: 30))
                            .foregroundColor(Color.white)
                            .frame(minWidth:0, maxWidth: 300)
                    }
                    .frame(minWidth:0, maxWidth: 375)
                    .background(ButtonGradient)
                    .cornerRadius(7)
                }
                
                //Login Button
                 NavigationLink(destination: LoginView()){
                    Button(action: {
                        
                    }){
                        HStack(){
                            Text("Already have an account?")
                            .fontWeight(.regular)
                            .padding(8)
                            .font(.custom("Poppins", size: 14))
                            .foregroundColor(Color.gray)
               
                            
                            Text("Login Here")
                            .fontWeight(.bold)
                            .padding(8)
                            .font(.custom("Poppins", size: 14))
                            .foregroundColor(Color.gray)
                            
                        }
                    }
                    
                    
                        
                }
                .frame(minWidth:0, maxWidth: 375)
                .cornerRadius(7)
             
                }.frame(minWidth:0, maxWidth: 375)
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

#if DEBUG
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
#endif
