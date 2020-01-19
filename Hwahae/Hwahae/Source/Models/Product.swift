//
//  Products.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id, oily_score, dry_score, sensitive_score: Int?
    let thumbnail_image, title, price, full_size_image: String?

    enum CodingKeys: String, CodingKey {
        case id, oily_score, dry_score, sensitive_score
        case thumbnail_image, title, price, full_size_image
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try? values.decode(Int.self, forKey: .id)
        self.thumbnail_image = try? values.decode(String.self, forKey: .thumbnail_image)
        self.title = try? values.decode(String.self, forKey: .title)
        self.price = try? values.decode(String.self, forKey: .price)
        self.oily_score = try? values.decode(Int.self, forKey: .oily_score)
        self.dry_score = try? values.decode(Int.self, forKey: .dry_score)
        self.sensitive_score = try? values.decode(Int.self, forKey: .sensitive_score)
        self.full_size_image = try? values.decode(String.self, forKey: .full_size_image)
    }
}
