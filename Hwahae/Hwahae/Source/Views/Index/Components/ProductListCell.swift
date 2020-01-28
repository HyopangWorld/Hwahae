//
//  ProductListCell.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import Kingfisher
import KRWordWrapLabel

class ProductListCell: UICollectionViewCell {
    typealias Data = (id: Int, thumbnail_image: String, title: String, price: String)
    typealias UI = Constants.UI.IndexCell

    let productImageView = UIImageView()
    let titleLabel = KRWordWrapLabel()
    let prieceLabel = UILabel()

    var id: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: Data) {
        self.id = data.id

        titleLabel.text = data.title
        prieceLabel.text = data.price

        productImageView.do {
            $0.kf.setImage(with: URL(string: data.thumbnail_image), placeholder: UIImage(named: "placeholder"))
            $0.snp.updateConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalToSuperview().inset(UI.imageHeightInset)
            }
        }
    }

    func attribute() {
        productImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleToFill
            $0.layer.cornerRadius = UI.imageRadius
            $0.layer.borderColor = UI.imageBorderColor
            $0.layer.borderWidth = UI.imageBorderWidth
        }

        titleLabel.do {
            $0.font = UI.titleFont
            $0.textColor = UI.titleTextColor
            $0.numberOfLines = 2
            $0.lineBreakMode = .byWordWrapping
        }

        prieceLabel.do {
            $0.font = UI.priceFont
            $0.textColor = UI.priceTextColor
            $0.numberOfLines = 1
        }
    }

    func layout() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(prieceLabel)

        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().inset(UI.imageHeightInset)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(UI.titleTopMargin)
            $0.leading.trailing.equalToSuperview().inset(UI.leftMargin)
        }

        prieceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(UI.priceTopMargin)
            $0.leading.trailing.equalToSuperview().inset(UI.leftMargin)
        }
    }
}
