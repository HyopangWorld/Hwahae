//
//  DetailTests.swift
//  HwahaeTests
//
//  Created by 김효원 on 29/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import XCTest
import RxSwift

@testable import Hwahae

class DetailTests: XCTestCase {
    let disposeBag = DisposeBag()
    let network = ProductsNetworkMockUp()
    var viewModel: DetailViewModel!
    var model: DetailModel!

    override func setUp() {
        self.model = DetailModel(productsNetwork: network)
        self.viewModel = DetailViewModel(model: model)
    }
    
    func testSkinTypeList() {
        model.getProductDetail(id: 250)
            .subscribe(onNext: { result in
                let product = try? result.get()
                assert(product != nil, "Product Detail Getting Success")
            })
            .disposed(by: disposeBag)
    }
    
    func testParseData() {
        guard let productsData = ProductsDummyData.productJSONString.data(using: .utf8) else { return }
        guard let product = try? JSONDecoder().decode(ProductResponse<Product>.self, from: productsData) else { return }
        let parsedData = model.parseData(value: product.body)
        assert(parsedData?.id == 250, "Product ID Parsing Success")
    }
    
    func testGetAndParse() {
        viewModel.productDetailData.emit(onNext: { data in
                assert(data.id == 250)
            })
            .disposed(by: disposeBag)
        
        viewModel.viewWillAppear.accept(250)
    }
}
