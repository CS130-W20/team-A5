//
//  SaleItemTableView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 1/30/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//
import SwiftUI

struct SaleItemTableView : View {
    @State private var search: String = ""

    @State private var saleItems = SaleItemTestData.saleItems()
    /// view body
    var body: some View {
        // Provides NavigationController
        NavigationView {

//            VStack(alignment: .center){
//                TextField("Search", text: $search)
//                    .frame(width: 360)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
////                    .shadow(color: Color.gray, radius: 10, x: 5, y: 5)
//                    .font(Font.system(size: 36, design: .default))
//                    ScrollView {
//                        VStack {
//
//                            ForEach(saleItems) { saleItem in
//
//                                SaleItemCellView(saleItem: saleItem)
//                            }
//                        }
//                    }
//            }
            List {
                    ForEach(saleItems) { saleItem in
                        NavigationLink(destination: SaleItemDetailView(saleItem: saleItem)) {
                        SaleItemCellView(saleItem: saleItem)
                        }
                    }

            }
            .navigationBarItems(leading:
                Button(action: {
                    print("Edit button pressed...")
                }) {
                    Text("Menu")
                },
                trailing:
                Button(action: {
                    print("Edit button pressed...")
                }) {
                    Text("Profile")
                }
            )
        }.navigationBarTitle(Text("Home"))
    }
}
