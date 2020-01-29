//
//  HwahaeTests.swift
//  HwahaeTests
//
//  Created by 김효원 on 06/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import XCTest
import RxSwift

@testable import Hwahae

class IndexTests: XCTestCase {
    let disposeBag = DisposeBag()
    let network = ProductsNetworkMockUp()
    var viewModel: IndexViewModel!
    var model: IndexModel!

    override func setUp() {
        self.model = IndexModel(productsNetwork: network)
        self.viewModel = IndexViewModel(model: model)
    }
    
    func testSkinTypeList() {
        model.getSkinTypeProductList(page: 1, skinType: .oily)
            .subscribe(onNext: { result in
                let products = try? result.get()
                assert(products != nil, "Product List Getting Success")
            })
            .disposed(by: disposeBag)
    }
    
    func testProductSearch() {
        model.getSearchProductList(keyword: "아모레퍼시픽")
            .subscribe(onNext: { result in
                let products = try? result.get()
                assert(products != nil, "Product Search Getting Success")
            })
            .disposed(by: disposeBag)
    }
    
    func testParseData() {
        guard let productsData = ProductsDummyData.productsJSONString.data(using: .utf8) else { return }
        guard let product = try? JSONDecoder().decode(ProductResponse<[Product]>.self, from: productsData) else { return }
        guard let data = product.body.first else { return }
        let parsedData = model.parseData(value: [data])
        assert(parsedData.first?.id == 536, "Product List ID Parsing Success")
    }
    
    func testGetAndParse() {
        viewModel.cellData.drive(onNext: { (data) in
                guard let cell = data.first else { return }
                assert(cell.id == 536)
            })
            .disposed(by: disposeBag)
        
        viewModel.viewWillFetch.accept((1, .oily))
    }
}
