//
//  GitHub.swift
//  GitHubRepositorySearchSwiftUI
//
//  Created by yorifuji on 2021/06/07.
//

import Foundation

struct Owner: Decodable {
    var id: Int
    var avatarUrl: String
}

struct Repository: Decodable {
    var id: Int
    var fullName: String
    var owner: Owner
    var stargazersCount: Int
//    var watchersCount: Int    // invalid
    var language: String?   // contains null some repository
    var forksCount: Int
    var openIssuesCount: Int
    var htmlUrl: String
}

struct RepositoryDetail: Decodable {
    var subscribersCount: Int
}

struct SearchResponse: Decodable {
    var totalCount: Int
    var items: [Repository]

    var count: Int {
        items.count
    }
}
