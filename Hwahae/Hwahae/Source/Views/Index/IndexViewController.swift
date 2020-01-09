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
    let indicator = UIImageView()

    typealias Const = Constants.UI.Index

    override func bind(_ viewModel: IndexViewBindable) {
        self.disposeBag = DisposeBag()
    }

    override func attribute() {
        self.view.backgroundColor = Constants.UI.Base.backgroundColor
        UIApplication.shared.changeStatusbarColor(Const.searchBarColor)

        searchController.do {
            $0.hidesNavigationBarDuringPresentation = false
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.do {
                $0.placeholder = "검색".localizedCapitalized
                $0.backgroundColor = Const.searchBarColor
                $0.showsCancelButton = false
                $0.searchTextField.backgroundColor = .white
            }
        }

        navigationItem.do {
            $0.hidesSearchBarWhenScrolling = false
            $0.titleView = searchController.searchBar
        }
    }

    override func layout() { }
}

extension IndexViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}
