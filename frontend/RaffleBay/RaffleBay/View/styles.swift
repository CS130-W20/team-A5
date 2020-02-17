//
//  style.swift
//  RaffleBay
//
//  Created by Pierson Marks on 2/16/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

//********** CUSTOM STYLES **********//

//********** Views **********//

//Logo - Rafflebay
//Description: This is the element of our logo for Rafflebay with the correct colorings/text kerning/etc.
struct LogoView: View {
    var body: some View {
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
    }
}

//Tagline - Rafflebay
//Description: This is the element for the tagline for Rafflebay with the correct colorings/text kerning/etc.
struct DescriptionView: View {
    var body: some View {
        Text("Win items you love. Repeat.")
            .fontWeight(.medium)
            .font(.custom("Poppins", size: 18))
            .foregroundColor(Color.gray)
    }
}

//ShadowBox
//Description: Create a Blurry Rectangle to simulate a smaller shadow for a 3D effect. Typically used in a ZStack to be placed behind a button.
struct ShadowBoxView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .frame(minWidth:0, maxWidth: 250, minHeight:10, maxHeight: 10)
            .shadow(color: Color("PurpleBlue"), radius: 5.0, x: 0, y: 10)
            .offset(y:22)
            .opacity(0.6)
    }
}

                       


//********** Style Formats **********//

//Style Variables

//Button Gradient Color
//Description: Purple to Blue button color scheme.
let blueButtonGradient = LinearGradient(gradient: Gradient(colors: [Color("PurpleBlue"), Color("LightBlue")]),
                                        startPoint: .leading,
                                        endPoint: .trailing)

//Style Structs

//Text Field Styling - Flat Design Style
//Description: Replaces traditional text fields with a blank text field, single border, and open to extension/animation.
struct SignUpTextFieldStyle : TextFieldStyle {
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


//Big Blue Button Styling - Flat Design Style
//Description: Big Blue Button styling as a Call to Action. 
struct BigBlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .frame(minWidth:0, maxWidth: frameMaxWidth)
            .background(blueButtonGradient)
            .cornerRadius(7)
        
        
    }
}

//Big Clear Button Styling - Flat Design Style
//Description: Big Clear Button styling as a opposite choice to a Call to Action
struct BigClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .frame(minWidth:0, maxWidth: frameMaxWidth)
            .cornerRadius(7)
        
        
    }
}




//Text Field Styling - Flat Design Style
//Description: Replaces traditional text fields with a blank text field, single border, and open to extension/animation.

//Button Text Styles
//Description: The text style for the text inside any large blue buttons
extension Text {
    
    //Text style to be typically used inside Big Blue Buttons
    func blueButtonText() -> Text {
        self
            .foregroundColor(Color.white)
            .fontWeight(.medium)
            .font(.custom("Poppins", size: 30))
    }
    
    //Text Style to be typically used inside Big Clear Buttons
    func clearButtonText() -> Text {
        self
            .foregroundColor(Color.gray)
            .fontWeight(.regular)
            .font(.custom("Poppins", size: 24))
            
    }
    
    //Normal Text Style to be typically used for standard, non-bold text.
    //NEED TO CHANGE: Setting "size" will override any user preferences in iOS Accessiblity.
    func standardRegularText() -> Text {
        self
            .foregroundColor(Color.gray)
            .fontWeight(.regular)
            .font(.custom("Poppins", size: 14))

    }
    
    //Normal Bold Text Style to be typically used for standard, bold text.
       //NEED TO CHANGE: Setting "size" will override any user preferences in iOS Accessiblity.
    func standardBoldText() -> Text {
        self
            .foregroundColor(Color.gray)
            .fontWeight(.bold)
            .font(.custom("Poppins", size: 14))

   }
    
    
}



