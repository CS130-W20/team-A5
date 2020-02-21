//
//  AuthenticationViewModel.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/20/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var auth_token: String = UserDefaults.standard.string(forKey: "auth_token")! {
        didSet{
            UserDefaults.standard.set(self.auth_token, forKey: "auth_token")
        }
    }
}
