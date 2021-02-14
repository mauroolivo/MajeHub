//
//  ResponseSearchRepositories.swift
//  majeHub
//
//  Created by Mauro Olivo on 13/02/21.
//

// MARK: - ResponseSearchRepositories
struct ResponseSearchRepositories: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Repo]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
