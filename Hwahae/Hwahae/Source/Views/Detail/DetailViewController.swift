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

protocol DetailBindable {
    var viewWillAppear: PublishRelay<Int> { get }
    var productDetailData: Signal<DetailData> { get }
    var errorMessage: Signal<String> { get }
}

class DetailViewController: ViewController<DetailBindable> {
    let scrollView = UIScrollView()
    let fullImageView = UIImageView()
    let closeButton = UIButton()
    let titleLabel = KRWordWrapLabel()
    let priceLabel = UILabel()
    let line = UIView()
    let descriptionLabel = UILabel()
    let noticeView = UIView()
    let buyButton = UIButton()
    
    private typealias UI = Constants.UI.Detail
    private typealias TEXT = Constants.Text.Detail
    
    var id: Int? = 0
    
    override func viewDidLoad() {
        attribute()
    }
    
    override func bind(_ viewModel: DetailBindable) {
        self.disposeBag = DisposeBag()

        self.rx.viewWillAppear
            .take(1)
            .map { [weak self] _ in self?.id }
            .filterNil()
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)

        viewModel.productDetailData
            .emit(to: self.rx.setData)
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .emit(to: self.rx.toast())
            .disposed(by: disposeBag)

        closeButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        let detailData = viewModel.productDetailData.asObservable().share()
        detailData
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.layout()
            }
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .black
        
        scrollView.do {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
        }
        
        closeButton.do {
            $0.backgroundColor = UI.closeBtnColor
            $0.layer.cornerRadius = UI.closeBtnRadius
            $0.setImage(UIImage(named: "round_close_white.png"), for: .normal)
        }
        
        titleLabel.do {
            $0.font = UI.titleFont
            $0.textColor = UI.titleTextColor
            $0.numberOfLines = 10
        }
        
        priceLabel.do {
            $0.font = UI.priceFont
            $0.textColor = UI.priceTextColor
        }
        
        line.do {
            $0.backgroundColor = UI.lineColor
            $0.layer.cornerRadius = UI.lineRadius
        }
        
        descriptionLabel.do {
            $0.font = UI.descriptionFont
            $0.textColor = UI.descriptionTextColor
            $0.numberOfLines = 0
        }
        
        noticeView.do {
            $0.backgroundColor = UI.noticeColor
            $0.layer.cornerRadius = UI.noticeRadius
            let notice = UILabel()
            notice.do {
                $0.font = UI.noticeFont
                $0.textColor = UI.noticeTextColor
                $0.numberOfLines = 0
                $0.text = TEXT.notice
            }
            noticeView.addSubview(notice)
            notice.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(20)
            }
        }
        
        buyButton.do {
            $0.backgroundColor = UI.buyBtnColor
            $0.layer.cornerRadius = UI.buyBtnRadius
            $0.setTitle(TEXT.buyBtnTitle, for: .normal)
            $0.titleLabel?.textColor = UI.buyBtnTextColor
            $0.titleLabel?.font = UI.buyBtnFont
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
            $0.top.trailing.equalToSuperview().inset(UI.closeBtnTopMargin)
            $0.width.height.equalTo(UI.closeBtnHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(fullImageView.snp.bottom).offset(UI.titleTopMargin)
            $0.leading.trailing.equalToSuperview().inset(UI.titleSideMargin)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(UI.priceTopMargin)
            $0.leading.trailing.equalToSuperview().offset(UI.priceSideMargin)
        }
        
        line.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(UI.lineTopMargin)
            $0.leading.trailing.equalToSuperview().inset(UI.lineSideMargin)
            $0.height.equalTo(UI.lineHeight)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(UI.descriptiocnTopMargin)
            $0.leading.trailing.equalToSuperview().inset(UI.descriptionSideMargin)
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(UI.noticeTopMargin)
            $0.leading.trailing.equalToSuperview().inset(UI.noticeSideMargin)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UI.noticeHeight)
            $0.height.equalTo(UI.noticeTopMargin)
            $0.bottom.equalToSuperview().inset(UI.buyBtnHeight + UI.buyBtnTopMargin)
        }
        
        buyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UI.buyBtnHeight)
            $0.leading.trailing.equalToSuperview().inset(UI.buyBtnSideMargin)
            $0.height.equalTo(UI.buyBtnHeight)
        }
    }

    deinit {
        #if debug
        print("ProductDetailViewController 메모리 완전해제")
        #endif
    }
}

extension Reactive where Base: DetailViewController {
    var setData: Binder<DetailData> {
        return Binder(base) { base, data in
            base.fullImageView.kf.setImage(with: URL(string: data.full_size_image), placeholder: UIImage(named: "placeholder"))
            base.titleLabel.text = data.title
            base.descriptionLabel.text = data.description.replacingOccurrences(of: "\\n", with: "\n", options: NSString.CompareOptions.literal, range: nil)
            base.priceLabel.text = data.price
        }
    }
}
