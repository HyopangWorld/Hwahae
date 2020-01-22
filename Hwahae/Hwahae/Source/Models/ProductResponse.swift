//
//  ProductResponse.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

struct ProductResponse<T: Codable>: Codable {
    let statusCode: Int
    let body: T
    let scanned_count: Int?
}
