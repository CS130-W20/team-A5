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
            List {
                    ForEach(saleItems) { singleSaleItem in
                        NavigationLink(destination: SaleItemDetailView(saleItem: singleSaleItem)) {
                        SaleItemCellView(saleItem: singleSaleItem)
                        }
                    }
            }
        .navigationBarTitle("home")
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
        }
    }
}
