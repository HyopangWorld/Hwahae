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
import Then
import SnapKit

protocol IndexViewBindable {
    var viewWillAppear: PublishRelay<Int> { get }
    var viewWillFetch: PublishRelay<Int> { get }
    var cellData: Driver<[ProductListCell.Data]> { get }
    var reloadList: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
}

class IndexViewController: ViewController<IndexViewBindable> {
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let indicator = Indicator(image: UIImage(named: "outline_explore_black.png"))
    
    private typealias UI = Constants.UI.Index
    private typealias TEXT = Constants.Text.Index
    private var page = 1
    
    override func bind(_ viewModel: IndexViewBindable) {
        self.disposeBag = DisposeBag()
        
        self.rx.viewWillAppear
            .map { _ in 1 }
            .bind(to: viewModel.viewWillAppear)
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
                self?.indicator.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset((self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0) - 20) // collection 높이 - 여백
                }
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.toast())
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
            .delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance) // indicator animation delay
            .map { [weak self] _ -> Int? in
                self?.page += 1
                return self?.page
            }
            .filterNil()
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
                $0.showsCancelButton = false
                $0.searchTextField.backgroundColor = .white
            }
        }
        
        navigationItem.do {
            $0.hidesSearchBarWhenScrolling = false
            $0.titleView = searchController.searchBar
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.do {
            $0.scrollDirection = .vertical
            let size = view.frame.width / 2 - (UI.sideMargin + UI.centerMargin)  // 옆 마진 + 가운데 간격
            $0.itemSize = CGSize(width: size, height: size + UI.cellHeight)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = UI.bottomMargin
            $0.minimumInteritemSpacing = UI.centerMargin
            $0.headerReferenceSize = CGSize(width: view.bounds.width, height: UI.headerHieght)
            $0.footerReferenceSize = CGSize(width: view.bounds.width, height: UI.footerHieght)
        }
        
        collectionView.do {
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.backgroundColor = .white
            $0.register(ProductListCell.self, forCellWithReuseIdentifier: String(describing: ProductListCell.self))
            $0.setCollectionViewLayout(layout, animated: true)
            $0.showsVerticalScrollIndicator = false
        }
        
        indicator.do {
            $0.animation = Animations.spin
            $0.tintColor = UIColor(red: (171/255), green: (171/255), blue: (196/255), alpha: 1)
        }
    }
    
    override func layout() {
        collectionView.addSubview(indicator)
        view.addSubview(collectionView)
        
        let collectionHeight = (navigationController?.navigationBar.bounds.height ?? 0) + Constants.UI.Base.safeAreaInsetsTop
        collectionView.snp.makeConstraints {
            $0.top.equalTo(collectionHeight)
            $0.leading.equalToSuperview().offset(UI.sideMargin)
            $0.trailing.equalToSuperview().inset(UI.sideMargin)
            $0.bottom.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(UI.indicatorHieght)
        }
    }
}

extension IndexViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}
