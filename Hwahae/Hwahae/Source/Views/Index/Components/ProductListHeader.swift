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
    typealias TEXT = Constants.Text.IndexHeader
    typealias UI = Constants.UI.IndexHeader
    let disposeBag = DisposeBag()
    
    let skinTypeLabel = UILabel()
    let arrowImageView = UIImageView()
    let skinTypeButton = UIView()
    let skinTypeActionSheet = UIAlertController(title: TEXT.title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    var viewController: UIViewController? = UIViewController()
    
    let skinType = BehaviorSubject<SkinType>(value: .oily)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
        attribute()
        layout()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initalize()
        attribute()
        layout()
    }
    
    func initalize() {
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.oily.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeLabel.text = SkinType.oily.getSkinTypeName()
            self?.skinType.onNext(.oily)
        }))
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.dry.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeLabel.text = SkinType.dry.getSkinTypeName()
            self?.skinType.onNext(.dry)
        }))
        skinTypeActionSheet.addAction(UIAlertAction(title: SkinType.sensitive.getSkinTypeName(), style: .default, handler: { [weak self] _ in
            self?.skinTypeLabel.text = SkinType.sensitive.getSkinTypeName()
            self?.skinType.onNext(.sensitive)
        }))
        
        skinTypeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doPresentActionSheet)))
    }
    
    @objc func doPresentActionSheet() {
        viewController?.present(skinTypeActionSheet, animated: true, completion: nil)
    }
    
    func attribute() {
        self.backgroundColor = .white
        
        skinTypeLabel.do {
            $0.text = SkinType.oily.getSkinTypeName()
            $0.font = UI.buttonFont
            $0.textAlignment = .right
        }
        
        arrowImageView.image = UIImage(named: "arrow_down_black.png")
    }
    
    func layout() {
        skinTypeButton.addSubview(skinTypeLabel)
        skinTypeButton.addSubview(arrowImageView)
        self.addSubview(skinTypeButton)
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.height.centerY.equalToSuperview()
            $0.width.equalTo(UI.arrowWidth)
        }
        
        skinTypeLabel.snp.makeConstraints {
            $0.trailing.equalTo(arrowImageView.snp.leading)
            $0.leading.height.centerY.equalToSuperview()
        }
        
        skinTypeButton.snp.makeConstraints {
            $0.trailing.height.centerY.equalToSuperview().inset(UI.buttonMargin)
            $0.width.equalTo(UI.buttonWidth)
        }
    }
}
