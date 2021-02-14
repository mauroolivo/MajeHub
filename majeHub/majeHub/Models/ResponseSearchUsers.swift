//
//  ResponseSearchUsers.swift
//  majeHub
//
//  Created by Mauro Olivo on 13/02/21.
//

// MARK: - ResponseSearchUsers
struct ResponseSearchUsers: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [User]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
