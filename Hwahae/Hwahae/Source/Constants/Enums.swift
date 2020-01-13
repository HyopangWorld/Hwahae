//
//  Enums.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

enum SkinType: String {
    case all = "all"
    case oily = "oily"
    case dry = "dry"
    case sensitive = "sensitive"
    
    func getSkinTypeName() -> String {
        switch self {
        case .all:
            return "모든 피부 타입"
        case .oily:
            return "지성"
        case .dry:
            return "건성"
        case .sensitive:
            return "민감성"
        }
    }
}
