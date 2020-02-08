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

struct SignupView : View {
    var body: some View {
        
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            VStack(){
                Spacer()
                
                //Title
                HStack(spacing: 0){
                    Text("raffle")
                    .fontWeight(.black)
                    .font(.custom("Poppins", size: 70))
                    .foregroundColor(Color("LightYellow"))
                    
                    Text("bay")
                    .fontWeight(.black)
                    .font(.custom("Poppins", size: 70))
                    .foregroundColor(Color("LightBlue"))
                }
                
                
                //Description/Tagline
                Text("Win items you love. Repeat.")
                    .fontWeight(.medium)
                    .font(.custom("Poppins", size: 18))
                    .foregroundColor(Color.gray)
                
                Spacer()
                
                //Login Stack
                //ZStack here to allow for custom shadow manipulation.
                ZStack(){
                    //Create a Rectangle behind the button to simulate a smaller shadow for a 3D effect.
                    RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    
                    .frame(minWidth:0, maxWidth: 250, minHeight:10, maxHeight: 10)
                    .shadow(color: Color("PurpleBlue"), radius: 5.0, x: 0, y: 10)
                    .offset(y:22)
                    .opacity(0.6)
                    
                    //Login Button
                    Button(action: {
                        
                    }){
                        Text("Login")
                            .fontWeight(.medium)
                            .padding(10)
                            .font(.custom("Poppins", size: 30))
                            .foregroundColor(Color.white)
                            .frame(minWidth:0, maxWidth: 300)
                    }
                    .frame(minWidth:0, maxWidth: 300)
                    .background(ButtonGradient)
                    .cornerRadius(7)
                }
                
                //Signup Button
                //Login Button
                Button(action: {
                    
                }){
                    Text("Signup")
                        .fontWeight(.regular)
                        .padding(8)
                        .font(.custom("Poppins", size: 24))
                        .foregroundColor(Color.gray)
                        .frame(minWidth:0, maxWidth: 300)
                        
                }
                .frame(minWidth:0, maxWidth: 300)
                .cornerRadius(7)
             
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
