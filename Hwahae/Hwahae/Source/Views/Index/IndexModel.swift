//
//  IndexModel.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import RxSwift

struct ProductListModel {
    private let productsNetwork: ProductsNetwork
    
    init(productsNetwork: ProductsNetwork = ProductsNetworkImpl()) {
        self.productsNetwork = productsNetwork
    }
    
    func getSkinTypeProductList(page: Int, skinType: SkinType) -> Observable<Result<[Product], ProductsNetworkError>> {
        return productsNetwork.getSkinTypeProducts(page: page, skinType: skinType)
    }
    
    func getSearchProductList(keyword: String) -> Observable<Result<[Product], ProductsNetworkError>> {
        return productsNetwork.getSearchProducts(keyword: keyword)
    }
    
    func parseData(value: [Product]) -> [ProductListCell.Data] {
        return value.map {
            (id: $0.id ?? 0, thumbnail_image: $0.thumbnail_image ?? "", title: $0.title ?? "", price: $0.price?.makeNumberToMoney() ?? "")
        }
    }
}
