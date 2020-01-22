//
//  IndexViewModel.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

struct IndexViewModel: IndexViewBindable {
    let disposeBag = DisposeBag()
    
    let viewWillFetch = PublishRelay<(Int, SkinType)>()
    let viewWillReload = PublishRelay<(Int, SkinType)>()
    let viewWillSearch = PublishRelay<String>()
    let cellData: Driver<[ProductListCell.Data]>
    let reloadList: Signal<Void>
    let errorMessage: Signal<String>
    
    init(model: IndexModel = IndexModel()){
        let productListResult = Observable.merge(viewWillFetch.asObservable(), viewWillReload.asObservable())
            .flatMap(model.getSkinTypeProductList)
            .asObservable()
            .share()
        
        let prouductSearchResult = viewWillSearch
            .flatMap(model.getSearchProductList)
            .asObservable()
            .share()
        
        let productListValue = Observable.merge(productListResult, prouductSearchResult)
            .map { result -> [Product]? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filterNil()
        
        let productEmptyListValue = Observable.merge(
            viewWillSearch.map { _ in Void() }.asObservable(),
            viewWillReload.map { _ in Void() }.asObservable())
            .map { _ -> [Product] in return [] }
            .share()
        
        let productListError = Observable.merge(productListResult, prouductSearchResult)
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()

        self.cellData = Observable.merge(productEmptyListValue, productListValue)
            .scan([]){ prev, newList in
                return newList.isEmpty ? [] : prev + newList
            }
            .map(model.parseData)
            .asDriver(onErrorDriveWith: .empty())

        self.reloadList = productListValue
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())

        self.errorMessage = Observable
            .merge(productListError)
            .asSignal(onErrorJustReturn: ProductsNetworkError.defaultError.message ?? "")
    }
}
