//
//  SplashscreenView.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/8/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

struct SplashscreenView: View {
    @EnvironmentObject var navigation: NavigationStack
    
    var body: some View {
        //Three column Horizontal stack. Spacers on left and right.
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            VStack(){
                Spacer()
                
                //Title
                LogoView()
                
                //Description/Tagline
                DescriptionView()
                
                Spacer()
                
                //Login Stack
                //ZStack here to allow for custom shadow manipulation.
                ZStack(){
                
                    ShadowBoxView()
                    
                    Button(action: {
                        self.navigation.login()
                        }){
                            Text("Login")
                            .blueButtonText()
                            .frame(minWidth:0, maxWidth: frameMaxWidth)
                    }.buttonStyle(BigBlueButtonStyle())
                }
                
                //Signup Button
                Button(action: {
                    self.navigation.signup()
                    }){
                        Text("Signup")
                        .clearButtonText()
                        .frame(minWidth:0, maxWidth: frameMaxWidth)
                }.buttonStyle(BigClearButtonStyle())
             
            }
            
            //Right Side Spacer
            Spacer()
        }
    }
}

struct SplashscreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashscreenView()
    }
}
