//
//  ProductsNetwork.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import RxSwift

enum ProductsNetworkError: Error {
    case error(String)
    case defaultError

    var message: String? {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "네트워크 오류"
        }
    }
}

protocol ProductsNetwork {
    func getSkinTypeProducts(page: Int, skinType: SkinType) -> Observable<Result<[Product], ProductsNetworkError>>
    func getSearchProducts(keyword: String) -> Observable<Result<[Product], ProductsNetworkError>>
    func getProduct(id: Int) -> Observable<Result<Product, ProductsNetworkError>>
}
