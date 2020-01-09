//
//  UISearchBar+Attribute.swift
//  Hwahae
//
//  Created by 김효원 on 09/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

extension UISearchBar {
    var searchField: UITextField? {
        value(forKey: "searchField") as? UITextField
    }
}
