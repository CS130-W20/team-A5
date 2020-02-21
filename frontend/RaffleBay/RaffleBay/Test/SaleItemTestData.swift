//
//  SaleItemTestData.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

struct SaleItemTestData {

    /// posts
    static func saleItems() -> [SaleItem] {
        let saleItem1 = SaleItem(item_name: "Bose QuietComfort 100", pic_url: "bose")
        let saleItem2 = SaleItem(item_name: "Bose QuietComfort 200", pic_url: "bose")
        let saleItem3 = SaleItem(item_name: "Bose QuietComfort 300", pic_url: "bose")
        let saleItem4 = SaleItem(item_name: "Bose QuietComfort 400", pic_url: "bose")
        let saleItem5 = SaleItem(item_name: "Bose QuietComfort 500", pic_url: "bose")
        let saleItem6 = SaleItem(item_name: "Bose QuietComfort 600", pic_url: "bose")



        return  [saleItem1, saleItem2, saleItem3, saleItem4, saleItem5, saleItem6]
    }
}
