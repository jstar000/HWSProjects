//
//  Result.swift
//  BucketList
//
//  Created by 임지성 on 6/23/24.
//

import Foundation

struct Result: Codable {
    let query: Query
    // "query"라는 key에 우리 query의 결과를 담음
}

struct Query: Codable {
    let pages: [Int: Page]
    // query 안에는 'pages'라는 딕셔너리가 있으며,
    // page IDs가 key고 Wikipedia pages 자체가 value로 들어감
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    // 각 페이지는 coordinate, title, terms 등의 수많은 정보를 포함함
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        return lhs.title < rhs.title
    }
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
        // 'description' key를 가진다면 terms[description]은 [String] 타입의 value를
        // 반환할 거고, 그 배열이 값을 가지면 배열의 첫 번째 요소를 반환함
        // <- 왜 전체 데이터가 아니라 첫 번째 요소만 반환하지..?
    }
}

