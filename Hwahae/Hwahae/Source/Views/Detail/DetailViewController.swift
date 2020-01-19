//
//  DetailViewController.swift
//  Hwahae
//
//  Created by 김효원 on 19/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KRWordWrapLabel

typealias DetailData = (id: Int, full_size_image: String, title: String, description: String, price: String)

protocol ProductDetailBindable {
}

class ProductDetailViewController: ViewController<ProductDetailBindable> {
    let scrollView = UIScrollView()
    let fullImageView = UIImageView()
    let closeButton = UIButton()
    let titleLabel = KRWordWrapLabel()
    let priceLabel = UILabel()
    let line = UIView()
    let descriptionLabel = UILabel()
    let noticeView = UIView()
    let buyButton = UIButton()
    
    var id: Int? = 0
    
    override func bind(_ viewModel: ProductDetailBindable) {
        self.disposeBag = DisposeBag()
        
        closeButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .black
        
        scrollView.do {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
        }
        
        fullImageView.do {
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
        }
        
        closeButton.do {
            $0.backgroundColor = UIColor(displayP3Red: (24/255), green: (24/255), blue: (40/255), alpha: 0.16)
            $0.layer.cornerRadius = 20
            $0.setImage(UIImage(named: "round_close_white.png"), for: .normal)
        }
        
        titleLabel.do {
            $0.font = .systemFont(ofSize: 40, weight: .bold)
            $0.textColor = UIColor(displayP3Red: (20/255), green: (20/255), blue: (40/255), alpha: 1)
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 10
        }
        
        line.do {
            $0.backgroundColor = UIColor(displayP3Red: (236/255), green: (236/255), blue: (245/255), alpha: 1)
            $0.layer.cornerRadius = 15
        }
        
        descriptionLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .bold)
            $0.textColor = UIColor(displayP3Red: (20/255), green: (20/255), blue: (40/255), alpha: 1)
            $0.numberOfLines = 0
        }
        
        noticeView.do {
            $0.backgroundColor = UIColor(displayP3Red: (246/255), green: (246/255), blue: (250/255), alpha: 1)
            $0.layer.cornerRadius = 15
            let notice = UILabel()
            notice.do {
                $0.font = .systemFont(ofSize: 14, weight: .bold)
                $0.textColor = UIColor(displayP3Red: (163/255), green: (163/255), blue: (181/255), alpha: 1)
                $0.numberOfLines = 0
                $0.text = "부랑구마켓은 통신판매중개자이며 통신판매의 당사자가 아닙니다. 따라서 부랑구마켓은 상품 거래정보 및 거래에 대하여 책임을 지지 않습니다."
            }
            noticeView.addSubview(notice)
            notice.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(20)
            }
        }
        
        buyButton.do {
            $0.backgroundColor = UIColor(displayP3Red: (255/255), green: (88/255), blue: (108/255), alpha: 1)
            $0.layer.cornerRadius = 15
            $0.setTitle("구매하기", for: .normal)
            $0.titleLabel?.textColor = .white
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    override func layout() {
        scrollView.addSubview(fullImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(line)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(noticeView)
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        view.addSubview(buyButton)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fullImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.width)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(fullImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(16)
            $0.leading.width.equalToSuperview().inset(26)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(10)
        }
        
        line.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(1)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(33)
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327)
            $0.height.equalTo(96)
            $0.bottom.equalToSuperview().inset(80)
        }
        
        buyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(-52)
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.height.equalTo(52)
        }
    }

    deinit {
        #if debug
        print("ProductDetailViewController 메모리 완전해제")
        #endif
    }
}
