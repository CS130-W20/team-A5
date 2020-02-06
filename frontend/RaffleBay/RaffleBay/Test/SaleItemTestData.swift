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
        let saleItem1 = SaleItem(name: "Bose QuietComfort 700", image: "bose")
        let saleItem2 = SaleItem(name: "Bose QuietComfort 700", image: "bose")
        let saleItem3 = SaleItem(name: "Bose QuietComfort 700", image: "bose")
        let saleItem4 = SaleItem(name: "Bose QuietComfort 700", image: "bose")
        return [saleItem1, saleItem1, saleItem2, saleItem3, saleItem4]
    }
}
