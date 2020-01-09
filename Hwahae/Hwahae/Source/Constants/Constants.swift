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
            static let fontSize: CGFloat = 15
            static let safeAreaInsetsTop = (UIApplication.shared.windows.first { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
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
    }

    struct Text {
        struct Index {
            static let searchPlaceholder = "검색".localizedCapitalized
        }
    }
}
