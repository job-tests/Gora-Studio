//
//  NewsModel.swift
//  GORA_TestTask
//
//  Created by Kirill Drozdov on 13.06.2022.
//

import Foundation

struct News: Codable {
    var articles: [Article]?
}

struct Article: Codable {
    let source: Source?
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id, name: String?
}

// ------------------------ //

enum NewsCategories: Int, CaseIterable {
    case science
    case sports
    case technology
    case business
    case entertainment
    case general
    case health

    var title: String {
        switch self {
        case .business:
            return "business"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        case .entertainment:
            return "entertainment"
        case .general:
            return "general"
        case .health:
            return "health"
        }
    }
}
