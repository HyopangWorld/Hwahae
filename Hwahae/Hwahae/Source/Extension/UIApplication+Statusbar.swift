//
//  UIApplication+StatusBar.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

extension UIApplication {
    func changeStatusbarColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBar = UIView()
            statusBar.frame = self.statusBarFrame
            statusBar.backgroundColor = color
            self.keyWindow?.addSubview(statusBar)
        } else {
           guard let statusBar: UIView = self.value(forKey: "statusBar") as? UIView else { return }
           statusBar.backgroundColor = color
        }
    }
}
