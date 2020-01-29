//
//  ProductNetworkMockUp.swift
//  HwahaeTests
//
//  Created by 김효원 on 28/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import RxSwift

@testable import Hwahae

struct ProductsNetworkMockUp: ProductsNetwork {
    func getSkinTypeProducts(page: Int, skinType: SkinType) -> Observable<Result<[Product], ProductsNetworkError>> {
        guard let data = ProductsDummyData.productsJSONString.data(using: .utf8) else {
            return .just(.failure(.error("Dummy Data 에러")))
        }
        
         do {
             let response = try JSONDecoder().decode(ProductResponse<[Product]>.self, from: data)
             return .just(.success(response.body))
         } catch {
             guard let response = try? JSONDecoder().decode(ProductResponse<String>.self, from: data) else {
                 return .just(.failure(.error("getSkinTypeProducts API 에러")))
             }
             return .just(.failure(.error(response.body)))
         }
    }
    
    func getSearchProducts(keyword: String) -> Observable<Result<[Product], ProductsNetworkError>> {
        guard let data = ProductsDummyData.searchJSONString.data(using: .utf8) else {
            return .just(.failure(.error("Dummy Data 에러")))
        }
        
         do {
             let response = try JSONDecoder().decode(ProductResponse<[Product]>.self, from: data)
             return .just(.success(response.body))
         } catch {
             guard let response = try? JSONDecoder().decode(ProductResponse<String>.self, from: data) else {
                 return .just(.failure(.error("getSearchProducts API 에러")))
             }
             return .just(.failure(.error(response.body)))
         }
    }
    
    func getProduct(id: Int) -> Observable<Result<Product, ProductsNetworkError>> {
        guard let data = ProductsDummyData.productJSONString.data(using: .utf8) else {
            return .just(.failure(.error("Dummy Data 에러")))
        }
        
         do {
             let response = try JSONDecoder().decode(ProductResponse<Product>.self, from: data)
             return .just(.success(response.body))
         } catch {
             guard let response = try? JSONDecoder().decode(ProductResponse<String>.self, from: data) else {
                 return .just(.failure(.error("getProduct API 에러")))
             }
             return .just(.failure(.error(response.body)))
         }
    }
}
