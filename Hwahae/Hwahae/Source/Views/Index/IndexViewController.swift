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
import RxSwiftExt
import Then
import SnapKit
import Toaster

protocol IndexViewBindable {
    var viewWillFetch: PublishRelay<(Int, SkinType)> { get }
    var viewWillReload: PublishRelay<(Int, SkinType)> { get }
    var viewWillSearch: PublishRelay<String> { get }
    var cellData: Driver<[ProductListCell.Data]> { get }
    var reloadList: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
}

class IndexViewController: ViewController<IndexViewBindable> {
    let searchController = UISearchController(searchResultsController: nil)
    let collectionLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let fetchIndicator = Indicator(image: UIImage(named: "outline_explore_black.png"))
    let header = ProductListHeader()
    
    private typealias UI = Constants.UI.Index
    private typealias TEXT = Constants.Text.Index
    private typealias NUM = Constants.Number.Index
    private var page = 1
    
    override func bind(_ viewModel: IndexViewBindable) {
        self.disposeBag = DisposeBag()
        header.viewController = self
        
        bindModelToView(viewModel)
        bindViewToModel(viewModel)
        
        collectionView.rx.contentOffset
            .filter { $0.y > 0 }
            .pairwise()
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let prev = event.element?.0.y, let new = event.element?.1.y else { return }
                let y = (self?.searchController.searchBar.frame.height ?? 0) + Constants.UI.Base.safeAreaInsetsTop
                if new >= Constants.UI.IndexCell.height + Constants.UI.Index.headerHieght {
                    self?.header.frame = CGRect(x: 0, y: y - (self?.header.frame.height ?? 0), width: self?.header.frame.width ?? 0, height: self?.header.frame.height ?? 0)
                } else if new <= Constants.UI.IndexCell.height {
                    self?.header.frame = CGRect(x: 0, y: y, width: self?.header.frame.width ?? 0, height: self?.header.frame.height ?? 0)
                } else {
                    guard let frame = self?.header.frame.offsetBy(dx: 0, dy: (prev - new)) else { return }
                    self?.header.frame = frame
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe { [weak self] event in
                guard let indexpath = event.element else { return }
                guard let cell = (self?.collectionView.cellForItem(at: indexpath) as? ProductListCell) else { return }
                
                let detailViewController = DetailViewController()
                let detailViewModel = DetailViewModel()
                detailViewController.id = cell.id
                detailViewController.bind(detailViewModel)
                
                detailViewController.modalPresentationStyle = .overFullScreen
                detailViewController.modalTransitionStyle = .coverVertical
                self?.presentViewController(detailViewController, animation: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    func bindModelToView(_ viewModel: IndexViewBindable) {
        viewModel.cellData
            .drive(collectionView.rx.items) { collection, row, data in
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListCell.self), for: IndexPath(row: row, section: 0))
                    as? ProductListCell else { return UICollectionViewCell() }
                cell.setData(data: data)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadList
            .emit(onNext: { [weak self] _ in
                self?.fetchIndicator.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset((self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0) - UI.indicatorTopMargin)
                }
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.alert())
            .disposed(by: disposeBag)

        viewModel.viewWillSearch.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.header.isHidden = true
                self?.fetchIndicator.isHidden = true
                self?.indicator.isHidden = false
                self?.indicator.startAnimating()
            }
            .disposed(by: disposeBag)

        viewModel.viewWillReload.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.header.isHidden = false
                self?.fetchIndicator.isHidden = false
                self?.indicator.isHidden = false
                self?.indicator.startAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewToModel(_ viewModel: IndexViewBindable) {
        self.rx.viewWillAppear
            .map { _ in (1, SkinType.oily) }
            .bind(to: viewModel.viewWillReload)
            .disposed(by: disposeBag)
        
        Observable.merge(
            header.skinType,
            searchController.searchBar.rx.cancelButtonClicked.withLatestFrom(header.skinType).asObservable())
            .skipUntil(viewModel.reloadList.asObservable())
            .map { [weak self] skinType -> (Int, SkinType) in
                self?.collectionView.goToScrollTop()
                self?.page = 1
                return (1, skinType)
            }
            .bind(to: viewModel.viewWillReload)
            .disposed(by: disposeBag)
        
        let collectionFetch = collectionView.rx.contentOffset
            .skipUntil(viewModel.reloadList.asObservable())
            .filter { [weak self] offset -> Bool in
                let height = (self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0) - (self?.collectionView.frame.height ?? 0) + (Constants.UI.Base.isEdge ? Constants.UI.Base.safeAreaInsetsTop : 0) // edge가 없으면 0으로 값을 잡는다.
                return Int(offset.y - height) == 0
            }
            .map { Int($0.y) }
        
        let collectionReload = viewModel.viewWillReload.asObservable().map { _ -> [Int] in return [] }
        
        Observable.merge(collectionReload, collectionFetch.map{ [$0] })
            .skipUntil(searchController.searchBar.rx.cancelButtonClicked.startWith(Void()))
            .withLatestFrom(collectionView.rx.willDisplayCell) { ($0, $1.at) }
            .filter{ [weak self] (val, at) in
                let lastAt = NUM.listCount * (self?.page ?? 0) - 1
                return val == [] ? true : (lastAt - Constants.Number.Index.lastCells <= at.row) // 허용 범위
            }
            .map { (val, _) in val }
            .scan([]){ prev, newVal -> [Int] in
                if prev.contains(newVal.first ?? 0) { return prev + [0] }
                return newVal.isEmpty ? [] : prev + newVal
            }
            .filter { ($0.last ?? 0) != 0 }
            .map { [weak self] _ -> Int? in
                self?.page += 1
                return self?.page
            }
            .filterNil()
            .withLatestFrom(header.skinType) { ($0, $1) }
            .bind(to: viewModel.viewWillFetch)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidEndEditing.asObservable()
            .withLatestFrom(searchController.searchBar.rx.text)
            .filter { $0 != "" }
            .filterNil()
            .bind(to: viewModel.viewWillSearch)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        self.view.backgroundColor = Constants.UI.Base.backgroundColor
        UIApplication.shared.changeStatusbarColor(UI.searchBarColor)
        
        searchController.do {
            $0.hidesNavigationBarDuringPresentation = false
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.do {
                $0.placeholder = TEXT.searchPlaceholder
                $0.backgroundColor = UI.searchBarColor
                if #available(iOS 13.0, *) { searchController.searchBar.searchTextField.backgroundColor = .white }
                $0.tintColor = .white
            }
        }
        
        navigationItem.do {
            $0.hidesSearchBarWhenScrolling = false
            $0.titleView = searchController.searchBar
        }
        
        collectionLayout.do {
            $0.scrollDirection = .vertical
            let size = view.frame.width / 2 - (UI.sideMargin + UI.centerMargin)
            $0.itemSize = CGSize(width: size, height: size + UI.cellHeight)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = UI.bottomMargin
            $0.minimumInteritemSpacing = UI.centerMargin
            $0.headerReferenceSize = CGSize(width: view.bounds.width, height: UI.bottomMargin + UI.headerHieght)
            $0.footerReferenceSize = CGSize(width: view.bounds.width, height: UI.footerHieght)
        }
        
        collectionView.do {
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.backgroundColor = .white
            $0.setCollectionViewLayout(collectionLayout, animated: true)
            $0.showsVerticalScrollIndicator = false
            $0.register(ProductListCell.self, forCellWithReuseIdentifier: String(describing: ProductListCell.self))
        }
        
        fetchIndicator.do {
            $0.animation = Animations.spin
            $0.tintColor = UI.indicatorColor
        }
    }
    
    override func layout() {
        collectionView.addSubview(fetchIndicator)
        view.addSubview(collectionView)
        view.addSubview(header)
        view.addSubview(indicator)
        
        let collectionHeight = searchController.searchBar.frame.height + Constants.UI.Base.safeAreaInsetsTop
        header.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(collectionHeight)
            $0.height.equalTo(UI.headerHieght)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(UI.indicatorHieght)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(collectionHeight)
            $0.leading.equalToSuperview().offset(UI.sideMargin)
            $0.trailing.equalToSuperview().inset(UI.sideMargin)
            $0.bottom.equalToSuperview()
        }
        
        fetchIndicator.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/2)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(UI.indicatorHieght)
        }
    }
}
