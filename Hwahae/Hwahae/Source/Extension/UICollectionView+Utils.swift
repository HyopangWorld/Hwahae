//
//  UIViewController+Utils.swift
//  Hwahae
//
//  Created by 김효원 on 13/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

extension UICollectionView {
    func goToScrollTop() {
        self.setContentOffset(CGPoint.zero, animated: true)
    }
}
