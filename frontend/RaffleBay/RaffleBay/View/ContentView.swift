//
//  ContentView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

//Creation of our own Navigation View
struct NavigationItem{
   var view: AnyView
}

final class NavigationStack: ObservableObject {
    @Published var viewStack: [NavigationItem] = []
    @Published var currentView: NavigationItem
    
    init(_ currentView: NavigationItem ){
       self.currentView = currentView
    }
    
    func unwind(){
       if viewStack.count == 0{
          return }
       let last = viewStack.count - 1
       currentView = viewStack[last]
       viewStack.remove(at: last)
    }
    
    func advance(_ view:NavigationItem){
       viewStack.append( currentView)
       currentView = view
    }
    
    func home( ){
       currentView = NavigationItem( view: AnyView(SaleItemTableView()))
       viewStack.removeAll()
    }
    
    func splashscreen( ){
       currentView = NavigationItem( view: AnyView(SplashscreenView()))
       viewStack.removeAll()
    }
    
    func login( ){
       currentView = NavigationItem( view: AnyView(LoginView()))
       viewStack.removeAll()
    }
    
    func signup( ){
       currentView = NavigationItem( view: AnyView(SignupView()))
       viewStack.removeAll()
    }
    
    func success( ){
       currentView = NavigationItem( view: AnyView(SuccessfulView()))
       viewStack.removeAll()
    }
    
    
}

struct NavigationHost: View{
   @EnvironmentObject var navigation: NavigationStack
   
   var body: some View {
      self.navigation.currentView.view
   }
}

//Check if we have some auth token
func whatView(token: String) -> AnyView{
//    if (token == ""){
        return AnyView(SplashscreenView())
//    }else{
//        return AnyView(SaleItemTableView())
    //}
    
}

struct ContentView: View {
    //@State private var selection = 0
    @ObservedObject var authenticationVM = AuthenticationViewModel()

    var body: some View {
        NavigationHost()
        .environmentObject(NavigationStack(
            NavigationItem( view: whatView(token: self.authenticationVM.auth_token))
                            ))
    
        
        
//        if self.authenticationVM.auth_token == "" {
//            return AnyView(SplashscreenView())
//        } else {
//            return AnyView(TabView(selection: $selection){
//                SaleItemTableView()
//                    .tabItem {
//                        VStack {
//                            Image("first")
//                            Text("First")
//                        }
//                    }
//                    .tag(0)
//                ProfileView()
//                    .tabItem {
//                        VStack {
//                            Image("second")
//                            Text("Second")
//                        }
//                    }
//                    .tag(1)
//            })
//        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
