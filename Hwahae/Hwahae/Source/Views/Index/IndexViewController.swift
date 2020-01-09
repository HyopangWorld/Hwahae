//
//  IndexViewController.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Then
import RxAppState

protocol IndexViewBindable { }

class IndexViewController: ViewController<IndexViewBindable> {
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let indicator = Indicator(image: UIImage(named: "outline_explore_black.png"))

    private typealias UI = Constants.UI.Index
    private typealias TEXT = Constants.Text.Index

    override func bind(_ viewModel: IndexViewBindable) {
        self.disposeBag = DisposeBag()
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
