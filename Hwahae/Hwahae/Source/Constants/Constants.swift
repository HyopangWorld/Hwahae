//
//  Constants.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct UI {
        struct Base {
            static let backgroundColor: UIColor = .white
            static let fontSize: CGFloat = 16
            static let safeAreaInsetsTop = (UIApplication.shared.windows.first { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
            static let isEdge: Bool = (safeAreaInsetsTop == 20)
        }

        struct Index {
            static let searchBarColor: UIColor = UIColor(red: (144/255), green: (19/255), blue: (254/255), alpha: 1)
            static let sideMargin: CGFloat = 12
            static let centerMargin: CGFloat = 12
            static let bottomMargin: CGFloat = 24
            static let headerHieght: CGFloat = 50
            static let footerHieght: CGFloat = 96
            static let cellHeight: CGFloat = 64
            static let indicatorHieght: CGFloat = 24
        }
        
        struct IndexCell {
            static let imageHeightInset: CGFloat = 40
            static let imageRadius: CGFloat = 14
            static let titleTopMargin: CGFloat = 4
            static let priceTopMargin: CGFloat = 2
            static let leftMargin: CGFloat = 8
            static let titleFont: UIFont = .systemFont(ofSize: Base.fontSize, weight: .bold)
            static let priceFont: UIFont = .systemFont(ofSize: Base.fontSize, weight: .bold)
            static let titleTextColor: UIColor = UIColor(displayP3Red: (20/255), green: (20/255), blue: (40/255), alpha: 1)
            static let priceTextColor: UIColor = UIColor(displayP3Red: (171/255), green: (171/255), blue: (196/255), alpha: 1)
        }
    }

    struct Text {
        static let monetaryUnit = "원"
        
        struct Index {
            static let searchPlaceholder = "검색".localizedCapitalized
        }
    }
}
