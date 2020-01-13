//
//  IndexViewController.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import RxDataSources
import Then
import SnapKit

protocol IndexViewBindable {
    var viewWillFetch: PublishRelay<(Int, SkinType)> { get }
    var viewWillReload: PublishRelay<(Int, SkinType)> { get }
    var cellData: Driver<[ProductListCell.Data]> { get }
    var reloadList: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
}

class IndexViewController: ViewController<IndexViewBindable> {
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let fetchIndicator = Indicator(image: UIImage(named: "outline_explore_black.png"))
    let reloadIndicator = UIActivityIndicatorView()
    let header = ProductListHeader()
    
    private typealias UI = Constants.UI.Index
    private typealias TEXT = Constants.Text.Index
    private var page = 1
    
    override func bind(_ viewModel: IndexViewBindable) {
        self.disposeBag = DisposeBag()
        
        header.viewController = self
        
        bindToView(viewModel: viewModel)
        bindToViewModel(viewModel: viewModel)
    }
    
    func bindToView(viewModel: IndexViewBindable) {
        viewModel.viewWillFetch.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.collectionView.isScrollEnabled = true
            }
            .disposed(by: disposeBag)
        
        viewModel.viewWillReload.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe {[weak self] _ in
                self?.reloadIndicator.startAnimating()
                self?.collectionView.isScrollEnabled = true
            }
            .disposed(by: disposeBag)
        
        viewModel.cellData
            .drive(collectionView.rx.items) { collection, row, data in
                let index = IndexPath(row: row, section: 0)
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListCell.self), for: index)
                    as? ProductListCell else { return UICollectionViewCell() }
                cell.setData(data: data)
                return cell
        }
        .disposed(by: disposeBag)
        
        viewModel.reloadList
            .emit(onNext: { [weak self] _ in
                self?.fetchIndicator.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset((self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0) - 20) // collection 높이 - 여백
                }
                self?.reloadIndicator.stopAnimating()
                self?.collectionView.isScrollEnabled = true
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.toast())
            .disposed(by: disposeBag)
    }
    
    func bindToViewModel(viewModel: IndexViewBindable) {
        self.rx.viewWillAppear
            .map { _ in (1, SkinType.all) }
            .bind(to: viewModel.viewWillFetch)
            .disposed(by: disposeBag)
        
        let skinTypeChange = header.skinType
            .map { [weak self] skin -> SkinType in
                self?.page = 1
                self?.collectionView.goToScrollTop()
                self?.reloadIndicator.startAnimating()
                self?.collectionView.isScrollEnabled = false
                return skin
        }
        
        skinTypeChange
            .skipUntil(viewModel.reloadList.asObservable())
            .map { (1, $0) }
            .bind(to: viewModel.viewWillReload)
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .skipUntil(viewModel.reloadList.asObservable())
            .filter { [weak self] offset -> Bool in
                let height = (self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0) - (self?.collectionView.frame.height ?? 0)
                + (Constants.UI.Base.isEdge ? 0 : Constants.UI.Base.safeAreaInsetsTop) // edge가 없으면 0으로 값을 잡는다.
                return Int(offset.y - height) == 0
            }
            .map{ Int($0.y) }
            .distinct()
            .map { [weak self] _ -> Int? in
                self?.page += 1
                return self?.page
            }
            .filterNil()
            .withLatestFrom(skinTypeChange) { ($0, $1) }
            .bind(to: viewModel.viewWillFetch)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        self.view.backgroundColor = Constants.UI.Base.backgroundColor
        UIApplication.shared.changeStatusbarColor(UI.searchBarColor)
        
        searchController.do {
            $0.hidesNavigationBarDuringPresentation = false
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.do {
                $0.placeholder = TEXT.searchPlaceholder
                $0.backgroundColor = UI.searchBarColor
                $0.searchTextField.backgroundColor = .white
                $0.tintColor = .white
            }
        }
        
        navigationItem.do {
            $0.hidesSearchBarWhenScrolling = false
            $0.titleView = searchController.searchBar
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.do {
            $0.scrollDirection = .vertical
            let size = view.frame.width / 2 - (UI.sideMargin + UI.centerMargin)
            $0.itemSize = CGSize(width: size, height: size + UI.cellHeight)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = UI.bottomMargin
            $0.minimumInteritemSpacing = UI.centerMargin
            $0.headerReferenceSize = CGSize(width: view.bounds.width, height: UI.bottomMargin)
            $0.footerReferenceSize = CGSize(width: view.bounds.width, height: UI.footerHieght)
        }
        
        collectionView.do {
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.backgroundColor = .white
            $0.setCollectionViewLayout(layout, animated: true)
            $0.showsVerticalScrollIndicator = false
            $0.register(ProductListCell.self, forCellWithReuseIdentifier: String(describing: ProductListCell.self))
        }
        
        fetchIndicator.do {
            $0.animation = Animations.spin
            $0.tintColor = UI.indicatorColor
        }
        
        reloadIndicator.style = .gray
    }
    
    override func layout() {
        view.addSubview(header)
        collectionView.addSubview(fetchIndicator)
        view.addSubview(collectionView)
        view.addSubview(reloadIndicator)
        
        let collectionHeight = searchController.searchBar.frame.height + Constants.UI.Base.safeAreaInsetsTop
        header.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(collectionHeight)
            $0.height.equalTo(UI.headerHieght)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.equalToSuperview().offset(UI.sideMargin)
            $0.trailing.equalToSuperview().inset(UI.sideMargin)
            $0.bottom.equalToSuperview()
        }
        
        fetchIndicator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(UI.indicatorHieght)
        }
        
        reloadIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
}

extension IndexViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}
