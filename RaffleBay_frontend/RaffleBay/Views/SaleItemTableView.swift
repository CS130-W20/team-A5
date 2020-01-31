//
//  SaleItemTableView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 1/30/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//
import SwiftUI

struct SaleItemTableView : View {
        
    /// posts
//    let posts = TestData.posts()
    
    /// view body
    var body: some View {
        
        // Provides NavigationController
        NavigationView {
            SaleItemCellView(saleItem: SaleItem(name: "meera", image: ""))
                
        }.navigationBarTitle(Text("Home"))
    }
}
