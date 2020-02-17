//
//  User.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

class User {
    
    //TODO: Fill out based on class diagram
    
    
    //Acount Information from Sign Up
    @State var firstName = String()
    @State var lastName =  String()
    @State var email = String()
    @State var password = String()
    @State var streetAddress = String()
    @State var city = String()
    @State var state = String()
    @State var zipcode = String()
    @State var phoneNumber = String()
    @State var birthdate = Date()
    
//    //Should these be all private and have public getters/setters?
//    init(firstName: String, lastName: String, email: String, password: String, streetAddress: String, city: String, state: String, zipcode: String, phoneNumber: String, birthdate: Date) {
//        self.firstName      = firstName
//        self.lastName       = lastName
//        self.email          = email
//        self.password       = password
//        self.streetAddress  = streetAddress
//        self.city           = city
//        self.state          = state
//        self.zipcode        = zipcode
//        self.phoneNumber    = phoneNumber
//        self.birthdate      = birthdate
//        
//    }
    
}
