//
//  DetailViewModel.swift
//  Hwahae
//
//  Created by 김효원 on 19/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift
import RxCocoa

struct DetailViewModel: DetailBindable {
    let disposeBag = DisposeBag()
    
    let viewWillAppear = PublishRelay<Int>()
    let productDetailData: Signal<DetailData>
    let errorMessage: Signal<String>
    
    init(model: DetailModel = DetailModel()) {
        let productDetailResult = viewWillAppear
            .flatMap(model.getProductDetail)
            .asObservable()
            .share()
        
        let productDetailValue = productDetailResult
            .map { result -> Product? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filterNil()
        
        let productDetailError = productDetailResult
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
        self.productDetailData = productDetailValue
            .map(model.parseData)
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
        
        self.errorMessage = Observable
            .merge(productDetailError)
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해 주세요")
    }
}
