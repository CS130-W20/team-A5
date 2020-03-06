//
//  ContentView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @ObservedObject var authenticationVM = AuthenticationViewModel()

    var body: some View {
        if self.authenticationVM.auth_token == "1" {
            return AnyView(SplashscreenView())
        } else {
            return AnyView(TabView(selection: $selection){
                SaleItemTableView()
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("First")
                        }
                    }
                    .tag(0)
                ProfileView()
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("Second")
                        }
                    }
                    .tag(1)
            })
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
