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
            static let isEdge: Bool = (safeAreaInsetsTop != 40)
            static let textBlack: UIColor = UIColor(displayP3Red: (20/255), green: (20/255), blue: (40/255), alpha: 1)
        }

        struct Index {
            static let searchBarColor: UIColor = UIColor(red: (144/255), green: (19/255), blue: (254/255), alpha: 1)
            static let buttonFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
            
            static let sideMargin: CGFloat = 12
            static let centerMargin: CGFloat = 12
            static let bottomMargin: CGFloat = 24
            static let headerHieght: CGFloat = 50
            static let footerHieght: CGFloat = 96
            static let cellHeight: CGFloat = 64
            
            static let indicatorHieght: CGFloat = 24
            static let indicatorColor: UIColor = UIColor(red: (171/255), green: (171/255), blue: (196/255), alpha: 1)
            static let indicatorTopMargin: CGFloat = 20
        }
        
        struct IndexCell {
            static let height: CGFloat = 236
            static let leftMargin: CGFloat = 8
            
            static let imageHeightInset: CGFloat = 40
            static let imageRadius: CGFloat = 14
            static let imageBorderColor: CGColor = UIColor(red: (24/255), green: (24/255), blue: (80/255), alpha: 0.04).cgColor
            static let imageBorderWidth: CGFloat = 1
            
            static let titleFont: UIFont = .systemFont(ofSize: Base.fontSize, weight: .bold)
            static let titleTextColor: UIColor = Base.textBlack
            static let titleTopMargin: CGFloat = 4
            
            static let priceTopMargin: CGFloat = 2
            static let priceFont: UIFont = .systemFont(ofSize: Base.fontSize, weight: .bold)
            static let priceTextColor: UIColor = UIColor(displayP3Red: (171/255), green: (171/255), blue: (196/255), alpha: 1)
        }
        
        struct IndexHeader {
            static let buttonFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
            static let buttonWidth: CGFloat = 104
            static let buttonMargin: CGFloat = 12
            static let arrowWidth: CGFloat = 24
        }
        
        struct Detail {
            static let bgColor: UIColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
            static let scrollRadius: CGFloat = 20
            static let scrollTopMargin: CGFloat = Base.safeAreaInsetsTop + 14
            
            static let closeBtnColor: UIColor = UIColor(displayP3Red: (24/255), green: (24/255), blue: (40/255), alpha: 0.16)
            static let closeBtnRadius: CGFloat = 20
            static let closeBtnMargin: CGFloat = 16
            static let closeBtnHeight: CGFloat = 40
            
            static let titleFont: UIFont = .systemFont(ofSize: 32, weight: .bold)
            static let titleTextColor: UIColor = Base.textBlack
            static let titleTopMargin: CGFloat = 34
            static let titleSideMargin: CGFloat = 24
            
            static let priceFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
            static let priceTextColor: UIColor = UIColor(displayP3Red: (144/255), green: (19/255), blue: (254/255), alpha: 1)
            static let priceTopMargin: CGFloat = 28
            static let priceSideMargin: CGFloat = 24
            
            static let lineColor: UIColor = UIColor(displayP3Red: (236/255), green: (236/255), blue: (245/255), alpha: 1)
            static let lineRadius: CGFloat = 15
            static let lineTopMargin: CGFloat = 32
            static let lineSideMargin: CGFloat = 24
            static let lineHeight: CGFloat = 1
            
            static let descriptionFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let descriptionTextColor: UIColor = Base.textBlack
            static let descriptiocnTopMargin: CGFloat = 24
            static let descriptionSideMargin: CGFloat = 24
            
            static let noticeColor = UIColor(displayP3Red: (246/255), green: (246/255), blue: (250/255), alpha: 1)
            static let noticeRadius: CGFloat = 15
            static let noticeFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
            static let noticeTextColor: UIColor = UIColor(displayP3Red: (163/255), green: (163/255), blue: (181/255), alpha: 1)
            static let noticeTopMargin: CGFloat = 68
            static let noticeSideMargin: CGFloat = 24
            static let noticeWidth: CGFloat = 327
            static let noticeHeight: CGFloat = 96
            static let noticeInset: CGFloat = 20
            
            static let buyBtnColor: UIColor = UIColor(displayP3Red: (144/255), green: (19/255), blue: (254/255), alpha: 1)
            static let buyBtnRadius: CGFloat = 15
            static let buyBtnTextColor: UIColor = .white
            static let buyBtnFont: UIFont = .systemFont(ofSize: 18, weight: .bold)
            static let buyBtnSideMargin: CGFloat = 24
            static let buyBtnTopMargin: CGFloat = 40
            static let buyBtnBottomMargin: CGFloat = 30
            static let buyBtnHeight: CGFloat = 52
        }
    }

    struct Text {
        static let monetaryUnit = "원"
        
        struct Index {
            static let searchPlaceholder = "검색".localizedCapitalized
            static let title = "피부 타입을 선택해주세요".localizedCapitalized
        }
        
        struct IndexHeader {
            static let title = "피부 타입을 선택해주세요".localizedCapitalized
        }
        
        struct Detail {
            static let notice = "부랑구마켓은 통신판매중개자이며 통신판매의 당사자가 아닙니다. 따라서 부랑구마켓은 상품 거래정보 및 거래에 대하여 책임을 지지 않습니다."
            static let buyBtnTitle = "구매하기"
        }
    }
    
    struct Number {
        struct Index {
            static let listCount: Int = 20
            static let lastCells: Int = 5
        }
        
        struct Detail {
            static let btnAniDelay: Int = 1000
            static let rebound: CGFloat = 3
        }
    }
}
