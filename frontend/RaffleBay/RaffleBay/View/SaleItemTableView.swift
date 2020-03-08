//
//  SaleItemTableView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI

//Create a GridView to display sale items in a grid fashion.
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct SaleItemTableView : View {
    @EnvironmentObject var navigation: NavigationStack

    @ObservedObject var currUser = User()
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    @State private var search: String = ""

    @State private var saleItems = SaleItemTestData.saleItems()
    
    /// view body
    var body: some View {

        VStack(){
            HStack(){
                VStack(){
                    Button(action: {
                        self.navigation.advance(
                            NavigationItem( view: AnyView(SidebarNavView())))
                    }){
                         HamburgerIconView()
                    }
                    .foregroundColor(Color("LightGray"))
                }
                Spacer()
                VStack(){
                    Button(action: {
                        self.navigation.advance(
                        NavigationItem( view: AnyView(ProfileView())))
                    }){
                         Image("profile")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("LightGray"))
                    }

                }
            }
            Spacer().frame(height: 30)
//            TextField("Search", text: $search)
//                .padding(20)
//                .background(RoundedRectangle(cornerRadius: 8)
//                .foregroundColor(Color.white).frame(height: frameMaxWidth * 1.1 / 7))
//                .shadow(radius: 7, y: 5)
//                //.frame(height: frameMaxWidth * 1.1 / 7)
//            Spacer().frame(height: 30)

            HStack(){
                Text("Items for Sale")
                    .fontWeight(.bold)

                Spacer()

            }
            ScrollView(){
                //Currently this will only show the first even number of items. If there is a an odd number of sale items, the last item will not show. Will be slightly challenging to display that last item.
                GridStack(rows: saleItems.count / 2, columns: 2) { row, col in
                        Button(action:{
                             self.navigation.advance(NavigationItem( view: AnyView(SaleItemDetailView(currUser: self.currUser, authenticationVM: self.authenticationVM, saleItem: self.saleItems[row * 2 + col]) )))
                        }){
                            SaleItemCellView(saleItem: self.saleItems[row * 2 + col])
                            .padding(5)
                        }.buttonStyle(PlainButtonStyle())

                }
            }
    }
    .padding(20)
    .onAppear {if self.currUser.lastName == "" {get_user_request(auth_token: self.authenticationVM.auth_token, user: self.currUser)}}
    }

}

struct SaleItemTableView_Previews: PreviewProvider {
    static var previews: some View {
        SaleItemTableView()
    }
}
