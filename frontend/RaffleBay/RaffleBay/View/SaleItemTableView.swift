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
    @State private var search: String = ""

    @State private var saleItems = SaleItemTestData.saleItems()
    /// view body
    var body: some View {

        VStack(){
            //Currently this will only show the first even number of items. If there is a an odd number of sale items, the last item will not show. Will be slightly challenging to display that last item.
            GridStack(rows: saleItems.count / 2, columns: 2) { row, col in
                SaleItemCellView(saleItem: self.saleItems[row * 2 + col])
                    .padding(5)
            }
        }
        
        
        
        
//        NavigationView {
//        List {
//                ForEach(saleItems) { singleSaleItem in
//                    NavigationLink(destination: SaleItemDetailView(saleItem: singleSaleItem)) {
//                    SaleItemCellView(saleItem: singleSaleItem)
//                    }
//                }
//        }
//        .navigationBarTitle("home")
//            .navigationBarItems(leading:
//                Button(action: {
//                    print("Edit button pressed...")
//                }) {
//                    Text("Menu")
//                },
//                trailing:
//                Button(action: {
//                    print("Edit button pressed...")
//                }) {
//                    Text("Profile")
//                }
//            )
//        }
    }
}
