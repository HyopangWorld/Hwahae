//
//  ProductListHeader.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductListHeader: UIView {
    let disposeBag = DisposeBag()
    
    let skinTypeButton = UIButton()
    let skinTypeActionSheet = UIAlertController(title: "피부 타입을 선택해주세요", message: "피부타입", preferredStyle: UIAlertController.Style.actionSheet)
    var viewController: UIViewController? = UIViewController()
    
    let skinType = BehaviorSubject<SkinType>(value: .all)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
        attribute()
        layout()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initalize()
    }
    
    func initalize() {
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.all.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeButton.setTitle(SkinType.all.getSkinTypeName(), for: .normal)
            self?.skinType.onNext(.all)
        }))
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.oily.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeButton.setTitle(SkinType.oily.getSkinTypeName(), for: .normal)
            self?.skinType.onNext(.oily)
        }))
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.dry.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeButton.setTitle(SkinType.dry.getSkinTypeName(), for: .normal)
            self?.skinType.onNext(.dry)
        }))
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.sensitive.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeButton.setTitle(SkinType.sensitive.getSkinTypeName(), for: .normal)
            self?.skinType.onNext(.sensitive)
        }))
        
        skinTypeButton.rx.controlEvent(.touchUpInside).asObservable()
            .subscribe { [weak self] _ in
                guard let actionSheet = self?.skinTypeActionSheet else { return }
                self?.viewController?.present(actionSheet, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        attribute()
        layout()
    }
    
    func attribute() {
        skinTypeButton.do {
            $0.setTitle(SkinType.all.getSkinTypeName(), for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 13)
        }
    }
    
    func layout() {
        self.addSubview(skinTypeButton)
        
        skinTypeButton.snp.makeConstraints {
            $0.trailing.height.centerY.equalToSuperview().inset(10)
            $0.width.equalTo(100)
        }
    }
}
