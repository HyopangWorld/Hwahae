//
//  String+Utils.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

extension String {
    func makeNumberToMoney() -> String {
        var price = Array(String(self))
        var pointer = price.count - 3
        
        while pointer > 0 {
            price.insert(",", at: pointer)
            pointer -= 3
        }
        
        return "\(String(price))" + Constants.Text.monetaryUnit
    }
}
