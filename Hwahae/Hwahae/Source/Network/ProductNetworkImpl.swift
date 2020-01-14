//
//  ProductNetworkImpl.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductsNetworkImpl: ProductsNetwork {
    private let session: URLSession
    private let timeoutInterval: TimeInterval = 30

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getSkinTypeProducts(page: Int, skinType: SkinType) -> Observable<Result<[Product], ProductsNetworkError>> {
        guard let url = makeGetSkinTypeProductsComponents(page: page, skinType: skinType).url else {
            let error = ProductsNetworkError.error("유효하지 않은 URL입니다.")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url, timeoutInterval: timeoutInterval))
            .map { data in
                do {
                    let response = try JSONDecoder().decode(ProductResponse<[Product]>.self, from: data)
                    return .success(response.body)
                } catch {
                    return .failure(.error("getSkinTypeProducts API 에러"))
                }
            }
    }

    func getSearchProducts(keyword: String) -> Observable<Result<[Product], ProductsNetworkError>> {
        guard let url = makeGetSearchProductsComponents(keyword: keyword).url else {
            let error = ProductsNetworkError.error("유효하지 않은 URL입니다.")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url, timeoutInterval: timeoutInterval))
            .map { data in
                do {
                    let response = try JSONDecoder().decode(ProductResponse<[Product]>.self, from: data)
                    return .success(response.body)
                } catch {
                    return .failure(.error("getSearchProducts API 에러"))
                }
            }
    }

    func getProduct(id: Int) -> Observable<Result<[Product], ProductsNetworkError>> {
        guard let url = makeGetProductComponents(id: id).url else {
            let error = ProductsNetworkError.error("유효하지 않은 URL입니다.")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url, timeoutInterval: timeoutInterval))
            .map { data in
                do {
                    let response = try JSONDecoder().decode(ProductResponse<[Product]>.self, from: data)
                    return .success(response.body)
                } catch {
                    return .failure(.error("getProduct API 에러"))
                }
            }
    }
}

extension ProductsNetworkImpl {
    struct ProductAPI {
        static let scheme = "https"
        static let host = "6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com"
        static let path = "/prod"
    }

    func makeAPIComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = ProductAPI.scheme
        components.host = ProductAPI.host
        components.path = ProductAPI.path + "/products"
        return components
    }

    func makeGetSkinTypeProductsComponents(page: Int, skinType: SkinType) -> URLComponents {
        var components = makeAPIComponents()
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "skin_type", value: "\(skinType)")
        ]

        return components
    }

    func makeGetSearchProductsComponents(keyword: String) -> URLComponents {
        var components = makeAPIComponents()
        components.queryItems = [
            URLQueryItem(name: "search", value: keyword)
        ]

        return components
    }

    func makeGetProductComponents(id: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = ProductAPI.scheme
        components.host = ProductAPI.host
        components.path = ProductAPI.path + "/products" + "/\(id)"

        return components
    }
}
