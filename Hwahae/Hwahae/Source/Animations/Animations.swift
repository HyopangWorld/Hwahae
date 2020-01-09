//
//  Animations.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

struct Animations {
    static var spin: CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.5
        animationGroup.repeatCount = .infinity

        let pulseAnimation = CABasicAnimation(keyPath: "transform.rotation")
        pulseAnimation.toValue = 0.0
        pulseAnimation.fromValue = -Double.pi * 2
        pulseAnimation.duration = 0.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        let pulseAnimation2 = CABasicAnimation(keyPath: "transform.rotation")
        pulseAnimation2.toValue = 0.0
        pulseAnimation2.fromValue = -Double.pi * 2
        pulseAnimation2.duration = 0.5
        pulseAnimation2.timingFunction = CAMediaTimingFunction(name: .easeOut)

        animationGroup.animations = [pulseAnimation2, pulseAnimation]
        return animationGroup
    }
}
