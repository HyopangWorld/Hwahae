//
//  DetailModel.swift
//  Hwahae
//
//  Created by 김효원 on 19/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift

struct DetailModel {
    private let productsNetwork: ProductsNetwork
    
    init(productsNetwork: ProductsNetwork = ProductsNetworkImpl()) {
        self.productsNetwork = productsNetwork
    }
    
    func getProductDetail(id: Int) -> Observable<Result<Product, ProductsNetworkError>> {
        return productsNetwork.getProduct(id: id)
    }
    
    func parseData(val: Product) -> DetailData? {
        return (id: val.id ?? 0,
                full_size_image: val.full_size_image ?? "",
                title: val.title ?? "",
                description: val.description ?? "",
                price: val.price?.makeNumberToMoney() ?? "")
    }
}
