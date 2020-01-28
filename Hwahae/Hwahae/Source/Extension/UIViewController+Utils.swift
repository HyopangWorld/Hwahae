//
//  UIViewController+Utils.swift
//  Hwahae
//
//  Created by 김효원 on 28/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentViewController(_ viewController: UIViewController, animation: Bool = true, completion: (() -> Void)? = nil) {
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController
        currentViewController?.dismiss(animated: false, completion: nil)

        if self.presentedViewController == nil {
            currentViewController?.present(viewController, animated: animation, completion: completion)
        } else {
            self.present(viewController, animated: animation, completion: completion)
        }
    }
}
