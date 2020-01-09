//
//  SpinIndicator.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

class Indicator: UIImageView {
    var animation: CAAnimationGroup? {
        willSet {
            guard let new = newValue else { return }
            layer.add(new, forKey: nil)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        initalize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initalize() {
        layer.masksToBounds = true
    }
}
