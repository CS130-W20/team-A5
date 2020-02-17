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
    
    var body: some View {
        NavigationView {
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
                        
                        NavigationLink(destination: LoginView()){
                            Text("Login")
                                .blueButtonText()
                                .frame(minWidth:0, maxWidth: 300)
                        }
                        .buttonStyle(BigBlueButtonStyle())
                    }
                    
                    //Signup Button
                    NavigationLink(destination: LoginView()){
                        Text("Signup")
                            .clearButtonText()
                            .frame(minWidth:0, maxWidth: 300)
                    }
                    .buttonStyle(BigClearButtonStyle())
                 
                }
                
                //Right Side Spacer
                Spacer()
            }
        }
    }
}

struct SplashscreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashscreenView()
    }
}
